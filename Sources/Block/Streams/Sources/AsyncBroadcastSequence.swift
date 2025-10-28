//
//  AsyncBroadcastSequence.swift
//  Streams
//
//  Created by Stefano Mondino on 23/10/25.
//

// ===----------------------------------------------------------------------===//
//
// This source file is part of the Swift Async Algorithms open source project
//
// Copyright (c) 2022 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
// ===----------------------------------------------------------------------===//

// **IMPORTANT** as of today, the SwiftAsyncAlgorithms package does NOT allow broadcasting of sequences to multiple consumers.
// This is opposed to any other "Reactive" framework like RxSwift or Combine and caused multiple issues when migrating to a modern async-await approach.
// This implementation was first made available and then dropped by the SwiftAsyncAlgorithms team, in favor of the currently merged share() operator.
// Unfortunately, this operator is only available starting from iOS 18.
// As soon as https://github.com/apple/swift-async-algorithms/pull/369 is merged, broadcast can be removed and replaced by .share(), which is not EXACTLY the same but should cover our cases.

// NEVER USE THIS outside the ShareableAsyncStream context.

import AsyncAlgorithms
import DequeModule
import os

extension AsyncSequence where Self: Sendable, Element: Sendable {
    func broadcast() -> AsyncBroadcastSequence<Self> {
        AsyncBroadcastSequence(self)
    }
}

struct AsyncBroadcastSequence<Base: AsyncSequence>: Sendable where Base: Sendable, Base.Element: Sendable {
    struct State: Sendable {
        enum Terminal {
            case failure(Error)
            case finished
        }

        struct Side {
            var buffer = Deque<Element>()
            var terminal: Terminal?
            var continuation: UnsafeContinuation<Result<Element?, Error>, Never>?

            mutating func drain() {
                if !buffer.isEmpty, let continuation {
                    let element = buffer.removeFirst()
                    continuation.resume(returning: .success(element))
                    self.continuation = nil
                } else if let terminal, let continuation {
                    switch terminal {
                    case let .failure(error):
                        self.terminal = .finished
                        continuation.resume(returning: .failure(error))
                    case .finished:
                        continuation.resume(returning: .success(nil))
                    }
                    self.continuation = nil
                }
            }

            mutating func cancel() {
                buffer.removeAll()
                terminal = .finished
                drain()
            }

            mutating func next(_ continuation: UnsafeContinuation<Result<Element?, Error>, Never>) {
                assert(self.continuation == nil) // presume that the sides are NOT sendable iterators...
                self.continuation = continuation
                drain()
            }

            mutating func emit(_ result: Result<Element?, Error>) {
                switch result {
                case let .success(element):
                    if let element {
                        buffer.append(element)
                    } else {
                        terminal = .finished
                    }
                case let .failure(error):
                    terminal = .failure(error)
                }
                drain()
            }
        }

        var id = 0
        var sides = [Int: Side]()

        init() {}

        mutating func establish() -> Int {
            defer { id += 1 }
            sides[id] = Side()
            return id
        }

        fileprivate static func establish(_ state: ManagedCriticalState<State>) -> Int {
            state.withCriticalRegion { $0.establish() }
        }

        mutating func cancel(_ id: Int) {
            if var side = sides.removeValue(forKey: id) {
                side.cancel()
            }
        }

        fileprivate static func cancel(_ state: ManagedCriticalState<State>, id: Int) {
            state.withCriticalRegion { $0.cancel(id) }
        }

        mutating func next(_ id: Int, continuation: UnsafeContinuation<Result<Element?, Error>, Never>) {
            sides[id]?.next(continuation)
        }

        fileprivate static func next(_ state: ManagedCriticalState<State>, id: Int) async -> Result<Element?, Error> {
            await withUnsafeContinuation { continuation in
                state.withCriticalRegion { $0.next(id, continuation: continuation) }
            }
        }

        mutating func emit(_ result: Result<Element?, Error>) {
            for id in sides.keys {
                sides[id]?.emit(result)
            }
        }

        fileprivate static func emit(_ state: ManagedCriticalState<State>, result: Result<Element?, Error>) {
            state.withCriticalRegion { $0.emit(result) }
        }
    }

    struct Iteration {
        enum Status {
            case initial(Base)
            case iterating(Task<Void, Never>)
            case terminal
        }

        var status: Status

        init(_ base: Base) {
            status = .initial(base)
        }

        fileprivate static func task(_ state: ManagedCriticalState<State>, base: Base) -> Task<Void, Never> {
            Task {
                do {
                    for try await element in base {
                        State.emit(state, result: .success(element))
                    }
                    State.emit(state, result: .success(nil))
                } catch {
                    State.emit(state, result: .failure(error))
                }
            }
        }

        fileprivate mutating func start(_ state: ManagedCriticalState<State>) -> Bool {
            switch status {
            case .terminal:
                return false
            case let .initial(base):
                status = .iterating(Iteration.task(state, base: base))
            default:
                break
            }
            return true
        }

        mutating func cancel() {
            switch status {
            case let .iterating(task):
                task.cancel()
            default:
                break
            }
            status = .terminal
        }

        fileprivate static func start(_ iteration: ManagedCriticalState<Iteration>, state: ManagedCriticalState<State>) -> Bool {
            iteration.withCriticalRegion { $0.start(state) }
        }

        fileprivate static func cancel(_ iteration: ManagedCriticalState<Iteration>) {
            iteration.withCriticalRegion { $0.cancel() }
        }
    }

    fileprivate let state: ManagedCriticalState<State>
    fileprivate let iteration: ManagedCriticalState<Iteration>

    init(_ base: Base) {
        state = ManagedCriticalState(State())
        iteration = ManagedCriticalState(Iteration(base))
    }
}

extension AsyncBroadcastSequence: AsyncSequence {
    public typealias Element = Base.Element

    public struct Iterator: AsyncIteratorProtocol {
        final class Context {
            fileprivate let state: ManagedCriticalState<State>
            fileprivate var iteration: ManagedCriticalState<Iteration>
            let id: Int

            fileprivate init(_ state: ManagedCriticalState<State>, _ iteration: ManagedCriticalState<Iteration>) {
                self.state = state
                self.iteration = iteration
                id = State.establish(state)
            }

            deinit {
                State.cancel(state, id: id)
                if iteration.isKnownUniquelyReferenced() {
                    Iteration.cancel(iteration)
                }
            }

            func next() async rethrows -> Element? {
                guard Iteration.start(iteration, state: state) else {
                    return nil
                }
                defer {
                    if Task.isCancelled && iteration.isKnownUniquelyReferenced() {
                        Iteration.cancel(iteration)
                    }
                }
                return try await withTaskCancellationHandler {
                    let result = await State.next(state, id: id)
                    return try result.get()
                } onCancel: { [state, id] in
                    State.cancel(state, id: id)
                }
            }
        }

        let context: Context

        fileprivate init(_ state: ManagedCriticalState<State>, _ iteration: ManagedCriticalState<Iteration>) {
            context = Context(state, iteration)
        }

        public mutating func next() async rethrows -> Element? {
            try await context.next()
        }
    }

    public func makeAsyncIterator() -> Iterator {
        Iterator(state, iteration)
    }
}

@available(*, unavailable)
extension AsyncBroadcastSequence.Iterator: Sendable {}

private struct ManagedCriticalState<State> {
    private final class LockedBuffer: ManagedBuffer<State, Lock.Primitive> {
        deinit {
            withUnsafeMutablePointerToElements { Lock.deinitialize($0) }
        }
    }

    private var buffer: ManagedBuffer<State, Lock.Primitive>

    init(_ initial: State) {
        buffer = LockedBuffer.create(minimumCapacity: 1) { buffer in
            buffer.withUnsafeMutablePointerToElements { Lock.initialize($0) }
            return initial
        }
    }

    mutating func isKnownUniquelyReferenced() -> Bool {
        Swift.isKnownUniquelyReferenced(&buffer)
    }

    func withCriticalRegion<R>(_ critical: (inout State) throws -> R) rethrows -> R {
        try buffer.withUnsafeMutablePointers { header, lock in
            Lock.lock(lock)
            defer { Lock.unlock(lock) }
            return try critical(&header.pointee)
        }
    }

    func withLock<R>(_ critical: (inout State) throws -> R) rethrows -> R {
        return try withCriticalRegion(critical)
    }
}

extension ManagedCriticalState: @unchecked Sendable where State: Sendable {}
struct Lock {
    #if canImport(Darwin)
        typealias Primitive = os_unfair_lock
    #elseif canImport(Glibc) || canImport(Musl) || canImport(Bionic) || canImport(wasi_pthread)
        typealias Primitive = pthread_mutex_t
    #elseif canImport(WinSDK)
        typealias Primitive = SRWLOCK
    #else
        #error("Unsupported platform")
    #endif

    typealias PlatformLock = UnsafeMutablePointer<Primitive>
    let platformLock: PlatformLock

    private init(_ platformLock: PlatformLock) {
        self.platformLock = platformLock
    }

    fileprivate static func initialize(_ platformLock: PlatformLock) {
        #if canImport(Darwin)
            platformLock.initialize(to: os_unfair_lock())
        #elseif canImport(Glibc) || canImport(Musl) || canImport(Bionic) || canImport(wasi_pthread)
            let result = pthread_mutex_init(platformLock, nil)
            precondition(result == 0, "pthread_mutex_init failed")
        #elseif canImport(WinSDK)
            InitializeSRWLock(platformLock)
        #else
            #error("Unsupported platform")
        #endif
    }

    fileprivate static func deinitialize(_ platformLock: PlatformLock) {
        #if canImport(Glibc) || canImport(Musl) || canImport(Bionic) || canImport(wasi_pthread)
            let result = pthread_mutex_destroy(platformLock)
            precondition(result == 0, "pthread_mutex_destroy failed")
        #endif
        platformLock.deinitialize(count: 1)
    }

    fileprivate static func lock(_ platformLock: PlatformLock) {
        #if canImport(Darwin)
            os_unfair_lock_lock(platformLock)
        #elseif canImport(Glibc) || canImport(Musl) || canImport(Bionic) || canImport(wasi_pthread)
            pthread_mutex_lock(platformLock)
        #elseif canImport(WinSDK)
            AcquireSRWLockExclusive(platformLock)
        #else
            #error("Unsupported platform")
        #endif
    }

    fileprivate static func unlock(_ platformLock: PlatformLock) {
        #if canImport(Darwin)
            os_unfair_lock_unlock(platformLock)
        #elseif canImport(Glibc) || canImport(Musl) || canImport(Bionic) || canImport(wasi_pthread)
            let result = pthread_mutex_unlock(platformLock)
            precondition(result == 0, "pthread_mutex_unlock failed")
        #elseif canImport(WinSDK)
            ReleaseSRWLockExclusive(platformLock)
        #else
            #error("Unsupported platform")
        #endif
    }

    static func allocate() -> Lock {
        let platformLock = PlatformLock.allocate(capacity: 1)
        initialize(platformLock)
        return Lock(platformLock)
    }

    func deinitialize() {
        Lock.deinitialize(platformLock)
        platformLock.deallocate()
    }

    func lock() {
        Lock.lock(platformLock)
    }

    func unlock() {
        Lock.unlock(platformLock)
    }

    /// Acquire the lock for the duration of the given block.
    ///
    /// This convenience method should be preferred to `lock` and `unlock` in
    /// most situations, as it ensures that the lock will be released regardless
    /// of how `body` exits.
    ///
    /// - Parameter body: The block to execute while holding the lock.
    /// - Returns: The value returned by the block.
    func withLock<T>(_ body: () throws -> T) rethrows -> T {
        lock()
        defer {
            self.unlock()
        }
        return try body()
    }

    // specialise Void return (for performance)
    func withLockVoid(_ body: () throws -> Void) rethrows {
        try withLock(body)
    }
}

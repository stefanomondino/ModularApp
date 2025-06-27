//
//  Sequence+CombineLatest.swift
//  Tools
//
//  Created by Andrea Altea on 16/02/25.
//

import AsyncAlgorithms
import Foundation

private enum Double<T: Sendable, U: Sendable>: Sendable {
    case first(T)
    case second(U)
}

extension Array {
    private enum Wrapper<Value: Sendable>: Sendable {
        case empty
        case value(Value)

        var isFull: Bool {
            switch self {
            case .empty: false
            case .value: true
            }
        }

        var unsafeValue: Value {
            switch self {
            case let .value(value): value
            case .empty: fatalError("you shall not pass")
            }
        }
    }

    private func throwingSequencedStreams() -> AsyncThrowingStream<(Int, Element.Element), any Error> where Element: AsyncSequence & Sendable, Element.Element: Sendable {
        AsyncThrowingStream<(Int, Element.Element), any Error> { continuation in
            let task = Task {
                await withTaskGroup(of: Void.self) { group in
                    for (index, stream) in self.enumerated() {
                        group.addTask {
                            do {
                                for try await value in stream {
                                    continuation.yield((index, value))
                                }
                            } catch {
                                continuation.finish(throwing: error)
                            }
                        }
                    }

                    await group.waitForAll()
                    continuation.finish()
                }
            }

            continuation.onTermination = { _ in task.cancel() }
        }
    }

    private func nonThrowingSequencedStreams<Value: Sendable>() -> AsyncStream<(Int, Value)> where Element == AsyncStream<Value> {
        AsyncStream<(Int, Value)>((Int, Value).self) { continuation in
            let task = Task {
                await withTaskGroup(of: Void.self) { group in
                    for (index, stream) in self.enumerated() {
                        group.addTask {
                            do {
                                for await value in stream {
                                    continuation.yield((index, value))
                                }
                            }
                        }
                    }

                    await group.waitForAll()
                    continuation.finish()
                }
            }

            continuation.onTermination = { _ in task.cancel() }
        }
    }

    public func combineLatest<Value: Sendable>() -> AsyncStream<[Value]> where Element == AsyncStream<Value> {
        .init([Value].self) { continuation in
            let task = Task {
                var isFull = false
                var collection: [Wrapper<Value>] = .init(repeating: .empty, count: self.count)

                do {
                    for await (index, value) in self.nonThrowingSequencedStreams() {
                        collection[index] = .value(value)

                        if isFull {
                            continuation.yield(collection.map(\.unsafeValue))
                        } else if collection.allSatisfy(\.isFull) {
                            isFull = true
                            continuation.yield(collection.map(\.unsafeValue))
                        }
                    }
                    continuation.finish()
                }
            }

            continuation.onTermination = { _ in task.cancel() }
        }
    }

    public func combineLatest<Value: Sendable>() -> AsyncThrowingStream<[Value], any Error> where Element: AsyncSequence & Sendable, Element.Element == Value {
        .init { continuation in
            let task = Task {
                var isFull = false
                var collection: [Wrapper<Value>] = .init(repeating: .empty, count: self.count)

                do {
                    for try await (index, value) in self.throwingSequencedStreams() {
                        collection[index] = .value(value)

                        if isFull {
                            continuation.yield(collection.map(\.unsafeValue))
                        } else if collection.allSatisfy(\.isFull) {
                            isFull = true
                            continuation.yield(collection.map(\.unsafeValue))
                        }
                    }
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }

            continuation.onTermination = { _ in task.cancel() }
        }
    }
}

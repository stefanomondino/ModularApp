//
//  Property.swift
//  ToolKit
//
//  Created by Stefano Mondino on 06/05/25.
//

import Foundation

@MainActor
public final class Property<Element: Sendable>: AsyncSequence {
    public init(_ value: Element) {
        strategy = .memory(default: value)
    }

    public init(_ strategy: Strategy) {
        self.strategy = strategy
    }

    public var value: Element {
        strategy.get()
    }

    private var strategy: Strategy
    private var continuations: [UUID: AsyncStream<Element>.Continuation] = [:]
    private func update(continuation: AsyncStream<Element>.Continuation?, id: UUID) async {
        continuations[id] = continuation
    }

    public func send(_ value: Element) {
        strategy.set(value)
        for continuation in continuations.values {
            continuation.yield(value)
        }
    }

    public func asAsyncStream() -> ShareableAsyncStream<Element> {
        stream()
    }

    public typealias AsyncIterator = ShareableAsyncStream<Element>.AsyncIterator

    public nonisolated func makeAsyncIterator() -> ShareableAsyncStream<Element>.AsyncIterator {
        stream().makeAsyncIterator()
    }

    private nonisolated func stream() -> ShareableAsyncStream<Element> {
        ShareableAsyncStream { [weak self] continuation in
            let id = UUID()
            let task = Task { [weak self] in
                guard let value = await self?.value else {
                    continuation.finish()
                    return
                }

                await self?.update(continuation: continuation, id: id)
                continuation.yield(value)
            }
            continuation.onTermination = { [weak self] _ in
                Task { [weak self] in
                    await self?.update(continuation: nil, id: id)
                    task.cancel()
                }
            }
        }
    }
}

public extension Property where Element: ExpressibleByNilLiteral {
    convenience init() {
        self.init(nil)
    }
}

public extension Property {
    @MainActor
    struct Strategy {
        fileprivate let get: @Sendable @MainActor () -> Element
        fileprivate let set: @Sendable @MainActor (Element) -> Void
        fileprivate init(get: @Sendable @MainActor @escaping () -> Element,
                         set: @Sendable @MainActor @escaping (Element) -> Void) {
            self.get = get
            self.set = set
        }

        public static func memory(default value: Element) -> Strategy {
            var storage: Element = value
            return .init(get: { storage },
                         set: { storage = $0 })
        }

        public static func custom(get: @Sendable @MainActor @escaping () -> Element,
                                  set: @Sendable @MainActor @escaping (Element) -> Void) -> Strategy {
            .init(get: get, set: set)
        }
    }
}

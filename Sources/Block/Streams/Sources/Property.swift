//
//  Property.swift
//  ToolKit
//
//  Created by Stefano Mondino on 06/05/25.
//

import Foundation

public actor Property<Element: Sendable>: AsyncSequence {
    public init(_ value: Element) {
        _value = value
    }

    private var _value: Element
    public var value: Element {
        get async { _value }
    }

    private var continuations: [UUID: AsyncStream<Element>.Continuation] = [:]
    private func update(continuation: AsyncStream<Element>.Continuation?, id: UUID) async {
        continuations[id] = continuation
    }

    public func send(_ value: Element) async {
        _value = value
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
                guard let value = await self?._value else {
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
    init() {
        self.init(nil)
    }
}

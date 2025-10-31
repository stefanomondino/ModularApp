//
//  ShareableAsyncStream.swift
//  ToolKit
//
//  Created by Stefano Mondino on 06/05/25.
//

import AsyncAlgorithms
import Foundation

public protocol ShareableStream: AsyncSequence, Sendable {
//    typealias Failure = Never
}

public struct ShareableAsyncStream<Element: Sendable>: ShareableStream {
    public typealias Continuation = AsyncStream<Element>.Continuation
    private let underlyingStream: AsyncShareSequence<AsyncStream<Element>>
    public func makeAsyncIterator() -> AsyncShareSequence<AsyncStream<Element>>.Iterator {
        underlyingStream.makeAsyncIterator()
    }

    public init(_ element: Element) {
        self.init { continuation in
            continuation.yield(element)
            continuation.finish()
        }
    }

    public init(_ callback: @Sendable @escaping (Continuation) -> Void) {
        underlyingStream =
            AsyncStream<Element> { continuation in
                callback(continuation)
            }.share()
    }

    public init(_ callback: @Sendable @escaping () async -> Self) {
        underlyingStream = AsyncStream { await callback().asAsyncStream() }.share()
    }

    public static func empty() -> Self {
        self.init {
            $0.finish()
        }
    }

    public static func just(_ element: Element) -> Self {
        .init(element)
    }
}

public extension AsyncSequence where Self: Sendable, Element: Sendable, Self.AsyncIterator: SendableMetatype {
    func asShareableStream() -> ShareableAsyncStream<Element> {
        if let myself = self as? ShareableAsyncStream<Element> {
            return myself
        }
        let sequence = share()
        return ShareableAsyncStream { continuation in
            let task = Task {
                for try await value in sequence {
                    continuation.yield(value)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}

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
    private let streamGenerator: @Sendable () -> AsyncStream<Element>
    public func makeAsyncIterator() -> AsyncStream<Element>.Iterator {
        streamGenerator().makeAsyncIterator()
    }

    public init(_ element: Element) {
        self.init { continuation in
            continuation.yield(element)
            continuation.finish()
        }
    }

    public init(_ element: Element = nil) where Element: ExpressibleByNilLiteral & Sendable {
        streamGenerator = {
            .init { continuation in
                continuation.yield(element)
                continuation.finish()
            }
        }
    }

    public init(_ callback: @Sendable @escaping (Continuation) -> Void) {
        streamGenerator = {
            AsyncStream<Element> { continuation in
                callback(continuation)
            }
        }
    }

//    public init(_ callback: @Sendable @escaping () async -> Self) {
//        streamGenerator = {
//            AsyncStream { await callback().asAsyncStream() }
//        }
//    }

    public static func empty() -> Self {
        self.init {
            $0.finish()
        }
    }

    public static func just(_ element: Element) -> Self {
        .init(element)
    }
}

public extension AsyncSequence where Self: Sendable, Element: Sendable {
    func asShareableStream() -> ShareableAsyncStream<Element> {
        if let myself = self as? ShareableAsyncStream<Element> {
            return myself
        }
        let sequence = broadcast()
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

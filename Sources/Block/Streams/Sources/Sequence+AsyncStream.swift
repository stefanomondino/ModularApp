//
//  Sequence+AsyncStream.swift
//  ToolKit
//
//  Created by Andrea Altea on 04/04/25.
//

private extension AsyncStream {
    init<Base: AsyncSequence>(from sequence: Base, file: StaticString = #file, line: UInt = #line) where Element == Base.Element {
        var iterator = sequence.makeAsyncIterator()
        // FIXME: In later swift versions, AsyncSequence protocol will likely have an associated error type.
        // FIXME: For now, produce an assertionFailure to let developer know to use an AsyncThrowingStream instead.
        self.init {
            do {
                return try await iterator.next()
            } catch {
                assertionFailure("AsyncSequence threw \(error.localizedDescription). Use AsyncThrowingStream instead", file: file, line: line)
                return nil
            }
        }
    }
}

private extension AsyncThrowingStream {
    init<Base: AsyncSequence>(from sequence: Base) where Element == Base.Element, Failure == Error, Element: Sendable {
        var iterator = sequence.makeAsyncIterator()
        self.init {
            try await iterator.next()
        }
    }
}

public extension AsyncStream where Element: Sendable {
    init(_ closure: @Sendable @escaping () async -> Self) {
        self.init { continuation in
            let task = Task {
                for await value in await closure() {
                    continuation.yield(value)
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    init(_ closure: @Sendable @escaping () async -> Element) {
        self.init { continuation in
            let task = Task {
                let value = await closure()
                continuation.yield(value)
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}

public extension AsyncThrowingStream where Failure == Error, Element: Sendable {
    init(_ closure: @Sendable @escaping () async throws -> Self) {
        self.init(Element.self) { continuation in
            let task = Task {
                do {
                    for try await value in try await closure() {
                        continuation.yield(value)
                    }
                    continuation.finish()

                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    init(_ closure: @Sendable @escaping () async throws -> Element) {
        self.init { continuation in
            let task = Task {
                do {
                    let value = try await closure()
                    continuation.yield(value)
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }

    init(_ closure: @Sendable @escaping () async -> Element) {
        self.init { continuation in
            let task = Task {
                let value = await closure()
                continuation.yield(value)
                continuation.finish()
            }
            continuation.onTermination = { _ in
                task.cancel()
            }
        }
    }
}

public extension AsyncSequence where Element: Sendable {
    /// Type erases the `AsyncSequence` into an `AsyncStream`
    /// - Returns: An `AsyncStream` created from the base `AsyncSequence`
    ///
    /// - Note: AsyncSequences do not expose their error type.
    /// So this function is available for both throwing and non-throwing `AsyncSequences`.
    /// It will produce an `assertionFailure` at runtime if the base sequence throws.
    func asAsyncStream(file: StaticString = #file, line: UInt = #line) -> AsyncStream<Element> {
        AsyncStream(from: self, file: file, line: line)
    }

    /// Type erases the `AsyncSequence` into an `AsyncThrowingStream`
    /// - Returns: An `AsyncThrowingStream` from the base `AsyncSequence`
    func asAsyncThrowingStream() -> AsyncThrowingStream<Element, Error> {
        AsyncThrowingStream(from: self)
    }
}

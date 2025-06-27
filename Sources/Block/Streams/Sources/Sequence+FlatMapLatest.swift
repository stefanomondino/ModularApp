//
//  Sequence+FlatMapLatest.swift
//  ReactiveStreams
//
//  Created by Andrea Altea on 17/04/25.
//

public extension AsyncSequence {
    func flatMapLatest<ResultSequence: AsyncSequence>(
        _ transformation: @Sendable @escaping (Element) async -> ResultSequence
    ) -> AsyncThrowingStream<ResultSequence.Element, any Error>
        where Element: Sendable, Self: Sendable, ResultSequence.Element: Sendable {
        AsyncThrowingStream<ResultSequence.Element, Swift.Error> { continuation in
            let task = Task {
                do {
                    var currentTask: Task<Void, Never>?
                    for try await element in self {
                        let stream = await transformation(element)
                        currentTask?.cancel()
                        currentTask = Task {
                            do {
                                for try await result in stream {
                                    continuation.yield(result)
                                }
                            } catch {
                                continuation.finish(throwing: error)
                            }
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

public extension AsyncStream {
    func flatMapLatest<Output: Sendable>(_ transformation: @Sendable @escaping (Element) async -> AsyncStream<Output>) -> AsyncStream<Output>
        where Element: Sendable, Self: Sendable, Output: Sendable {
        AsyncStream<Output>(Output.self) { continuation in
            let task = Task {
                var currentTask: Task<Void, Never>?
                for await element in self {
                    let stream = await transformation(element)
                    currentTask?.cancel()
                    currentTask = Task {
                        for await result in stream {
                            continuation.yield(result)
                        }
                    }
                }
                continuation.finish()
            }
            continuation.onTermination = { _ in task.cancel() }
        }
    }
}

import Foundation

@MainActor
public final class Signal<Element: Sendable>: AsyncSequence {
    public typealias AsyncIterator = ShareableAsyncStream<Element>.AsyncIterator

    public nonisolated func makeAsyncIterator() -> ShareableAsyncStream<Element>.AsyncIterator {
        stream().makeAsyncIterator()
    }

    public init() {}
    private var continuations: [UUID: AsyncStream<Element>.Continuation] = [:]
    private func update(continuation: AsyncStream<Element>.Continuation?, id: UUID) async {
        continuations[id] = continuation
    }

    public func send(_ value: Element) {
        for continuation in continuations.values {
            continuation.yield(value)
        }
    }

    public func asAsyncStream() -> ShareableAsyncStream<Element> {
        stream()
    }

    private nonisolated func stream() -> ShareableAsyncStream<Element> {
        ShareableAsyncStream { [weak self] continuation in
            let id = UUID()
            let task = Task { [weak self] in
                guard self != nil else {
                    continuation.finish()
                    return
                }
                await self?.update(continuation: continuation, id: id)
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

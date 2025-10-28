//
//  Sequence+Sink.swift
//  ReactiveStreams
//
//  Created by Andrea Altea on 17/04/25.
//

public extension AsyncSequence where Element: Sendable, Self: Sendable {
    func sink(_ action: @Sendable @escaping (Element) async -> Void,
              onError errorCallback: @Sendable @escaping (Error) -> Void = { _ in },
              onComplete completeCallback: @Sendable @escaping () -> Void = {}) -> Task<Void, Never> {
        Task {
            do {
                for try await element in self {
                    await action(element)
                }
                completeCallback()

            } catch {
                errorCallback(error)
            }
        }
    }
}

public extension AsyncStream where Element: Sendable, Self: Sendable {
    func sink(_ action: @Sendable @escaping (Element) async -> Void,
              onComplete completeCallback: @Sendable @escaping () -> Void = {}) -> Task<Void, Never> {
        Task {
            for await element in self {
                await action(element)
            }
            completeCallback()
        }
    }
}

// public extension AsyncSequence where Element: Sendable {
//    private func assignStrong<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Self.Element>,
//                                               on object: Root) -> Task<Void, Never> {
//        sink { @MainActor in
//            object[keyPath: keyPath] = $0
//        }
//    }
//
//    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Self.Element>,
//                                 on object: Root,
//                                 ownership: ObjectOwnership = .weak) -> Task<Void, Never> {
//        switch ownership {
//        case .strong:
//            assignStrong(to: keyPath, on: object)
//        case .weak:
//            sink { @MainActor [weak object] value in
//                object?[keyPath: keyPath] = value
//            }
//        case .unowned:
//            sink { @MainActor [unowned object] value in
//                object[keyPath: keyPath] = value
//            }
//        }
//    }
// }

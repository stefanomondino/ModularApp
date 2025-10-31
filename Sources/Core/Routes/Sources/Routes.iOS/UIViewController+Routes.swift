//
//  UIViewController+Routes.swift
//  Routes_iOS
//
//  Created by Stefano Mondino on 04/03/24.
//

import Foundation
import Logger
import UIKit

public protocol UIKitRoute: Route {
    /**
     Executes the route using given `viewController` as source.
     - Parameters:
        - viewController: The starting `UIViewController` to execute the route with.
     */
    var presentationMode: UIKitPresentationMode { get }
    var createViewController: @MainActor () async -> UIViewController? { get }
    @MainActor func execute(from viewController: UIViewController?) async
}

public enum UIKitPresentationMode: Sendable, Equatable {
    case push
    case present

    var swiftUIType: SwiftUIRoute.Type {
        switch self {
        case .push: return SwiftUINavigationRoute.self
        case .present: return SwiftUIModalRoute.self
        }
    }
}

public extension Router {
    @MainActor func viewController(for definition: some RouteDefinition) async -> UIViewController? {
        guard let route = await resolve(definition) as? UIKitRoute else { return nil }
        return await route.createViewController()
    }
}

public extension UIViewController {
    /**
        Subscribes current view controller to given `Router` so that every time a compatible `Route` is emitted it gets executed.

        > `UIViewController` is compatible with any `Route` conforming to `UIKitRoute`; any other type of Route will be ignored.

     - Parameters:
            - router: A router emitting routes. Every `Route` not conforming to `UIKitRoute` is ignored.
     - Returns:
        A `AnyCancellable` object that will keep the binding alive until it gets explicitly cancelled.
     */
    func subscribe(to router: Router,
                   with callback: @escaping (UIKitRoute?) async -> UIKitRoute? = { $0 }) -> Task<Void, Never> {
        Task { @MainActor [weak self] in
            for await definition in router.definitionStream {
                if let route = await callback(router.resolve(definition) as? UIKitRoute) {
                    await route.execute(from: self)
                }
            }
        }
    }
}

public extension UIWindow {
    func subscribe(to router: Router) -> Task<Void, Never> {
        Logger.log("Subscribing to router", level: .verbose, tag: .lifecycle)
        return Task(priority: .high) { @MainActor [weak self] in
            Logger.log("Subscribed to router", level: .verbose, tag: .lifecycle)
            for await definition in router.definitionStream {
                if let route = await router.resolve(definition) as? UIKitRoute {
                    await route.execute(from: self?.rootViewController)
                }
            }
        }
    }
}

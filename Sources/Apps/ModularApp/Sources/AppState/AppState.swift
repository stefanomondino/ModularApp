//
//  AppState.swift
//  ModularApp
//
//  Created by Stefano Mondino on 17/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DataStructures
import Foundation
import Observation
import Routes

@Observable @MainActor final class AppState: Service {
    enum State {
        /// Right after application start, before container is initialized
        case launching
        case home
    }

    static var empty: AppState {
        .init(router: .init(container: .init(), name: "Empty AppState Router"))
    }

    var serviceIdentifier: any ServiceIdentifier { ObjectIdentifier(Self.self) }
    var state: State = .launching
    let router: Router
    var isLocked: Bool = false
    var backgroundDate = Date()
    /// Creates a new AppState instance.
    /// - Parameter router: a router connected to the app state.
    init(router: Router) {
        self.router = router
    }

    func start() async {
        state = .home
        isLocked = true
    }

    func unlock() {
        state = .home
        isLocked = false
    }

    func goToAppSettings() {
        if true {
            router.send(.appSettings())
        }
    }

    func didFinishLaunching(with _: LaunchDelegateOptions?) -> Bool {
        return true
    }

    func didEnterBackground() {
        backgroundDate = Date()
    }

    func didBecomeActive() {
        if (-backgroundDate.timeIntervalSinceNow) > 5.seconds {
            isLocked = true
        }
    }
}

//
//  AppState.swift
//  ModularApp
//
//  Created by Stefano Mondino on 17/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DataStructures
import Observation
import Routes

@Observable @MainActor final class AppState {
    enum State {
        /// Right after application start, before container is initialized
        case launching
        case home
    }

    static var empty: AppState {
        .init(router: .init(container: .init(), name: "Empty AppState Router"))
    }

    var state: State = .launching
    let router: Router

    /// Creates a new AppState instance.
    /// - Parameter router: a router connected to the app state.
    init(router: Router) {
        self.router = router
    }

    func start() async {
        state = .home
    }
}

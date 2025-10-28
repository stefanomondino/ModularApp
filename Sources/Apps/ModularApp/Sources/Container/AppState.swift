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
    static var empty: AppState {
        .init(router: .init(container: .init(), name: "Empty AppState Router"))
    }

    var isConfigured: Bool = false
    let router: Router

    /// Creates a new AppState instance.
    /// - Parameter router: a router connected to the app state.
    init(router: Router) {
        self.router = router
    }
}

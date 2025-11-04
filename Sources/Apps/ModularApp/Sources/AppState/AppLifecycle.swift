//
//  AppLifecycle.swift
//  ModularApp
//
//  Created by Stefano Mondino on 17/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DataStructures
import DependencyContainer
import Foundation
import Observation
import Routes

@Observable @MainActor final class AppLifecycle: Service {
    static var empty: AppLifecycle {
        .init(router: .init(container: .init(), name: "Empty AppState Router"))
    }

    var serviceIdentifier: any ServiceIdentifier { ObjectIdentifier(Self.self) }

    let router: Router
    var backgroundDate = Date()
    var startViewModel: StartViewModel?
    /// Creates a new AppState instance.
    /// - Parameter router: a router connected to the app state.
    init(router: Router) {
        self.router = router
    }

    func start() async {
        router.send(.restart())
    }
}

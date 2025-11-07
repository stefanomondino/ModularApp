//
//  AppLifecycle.swift
//  ModularApp
//
//  Created by Stefano Mondino on 17/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DataStructures
import DependencyContainer
import DesignSystem
import Foundation
import Observation
import Routes
import Translations

@Observable @MainActor final class AppLifecycle: Lifecycle {
//    static var empty: AppLifecycle {
//        .init(router: .init(container: .init(), name: "Empty AppState Router"),
//              design: .init())
//    }

    let design: Design
    let router: Router
    let serviceManager: ServiceManager
    let vocabulary: Vocabulary
    /// Creates a new AppState instance.
    /// - Parameter router: a router connected to the app state.
    init(router: Router,
         design: Design,
         vocabulary: Vocabulary,
         serviceManager: ServiceManager) {
        self.router = router
        self.design = design
        self.vocabulary = vocabulary
        self.serviceManager = serviceManager
    }

    func start() async {
        router.send(.restart())
    }
}

//
//  AppContainer.swift
//  ModularApp
//
//  Created by Stefano Mondino on 11/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DependencyContainer
import DesignSystem
import Foundation
import Routes

actor AppContainer: DependencyContainer {
    let container = ObjectContainer()
    var isConfigured: Bool = false
    let routeContainer = Router.Container()
    var services: [String: any Service] { [:] }
    @MainActor lazy var state: AppState = .init(router: .init(container: routeContainer, name: "AppContainer"))

    @MainActor func setup() async {
        try? await Task.sleep(for: .seconds(2))
        Design.shared.setup()
        await setupRoutes()
        state.isConfigured = true
    }
}

struct NavigationRouteDefinition: RouteDefinition, Equatable {
    let identifier: String = UUID().uuidString
}

struct ModalRouteDefinition: RouteDefinition, Equatable {
    let identifier: String = UUID().uuidString
}

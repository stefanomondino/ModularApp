//
//  AppContainer.swift
//  ModularApp
//
//  Created by Stefano Mondino on 11/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import AppSettings
import DependencyContainer
import DesignSystem
import Foundation
import Onboarding
import Routes

actor AppContainer: DependencyContainer {
    let container = ObjectContainer()
    var isConfigured: Bool = false
    let routeContainer = Router.Container()
    var services: [String: any Service] { [:] }
    var features: [any Routes.Feature] = []
    @MainActor lazy var state: AppState = .init(router: .init(container: routeContainer,
                                                              name: "AppContainer"))

    @MainActor func setup() async {
        try? await Task.sleep(for: .seconds(2))
        Design.shared.setup()
        await setupNetworking()
        await setupRoutes()
        await setupFeatures()
        state.isConfigured = true
    }

    func setupFeatures() async {
        await features.append(Onboarding.Feature(self))
        await features.append(AppSettings.Feature(self))
    }
}

struct NavigationRouteDefinition: RouteDefinition, Equatable {
    let identifier: String = UUID().uuidString
}

struct ModalRouteDefinition: RouteDefinition, Equatable {
    let identifier: String = UUID().uuidString
}

extension AppContainer: Onboarding.FeatureContainer {
    func routeContainer() async -> Routes.Router.Container {
        routeContainer
    }
}

extension AppContainer: AppSettings.FeatureContainer {}

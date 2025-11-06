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
import Logger
import Onboarding
import Routes

import Authorization

// murray: import

@MainActor
final class AppContainer: DependencyContainer {
    let container = ObjectContainer()
    let routeContainer = Router.Container()
    let serviceManager: ServiceManager = .init()
    private var services: [any Service] {
        get async { await unsafeResolve() }
    }

    var features: [any Routes.Feature] = []
    @MainActor lazy var state: AppLifecycle = .init(router: .init(container: routeContainer,
                                                                  name: "AppContainer"),
                                                    design: .init(),
                                                    serviceManager: serviceManager)

    @MainActor func setup() async {
        await Logger.shared.add(logger: ConsoleLogger(logLevel: .verbose))

        await register(for: Design.self) { @MainActor in
            self.state.design
        }
        await unsafeResolve(Design.self).setup()
        await register(for: AppConfiguration.self, scope: .singleton) {
            EnvironmentImplementation()
        }
        await register(for: [any Service].self) { @MainActor [self] in
            await ([] +
                features
                .asyncFlatMap { await $0.services })
        }
        await setupNetworking()
        await setupRoutes()
        await setupDataSources()
        await setupRepositories()

        await register(for: StartUseCase.self, scope: .singleton) { @MainActor [self] in
            await StartUseCaseImplementation(permissions: unsafeResolve())
        }

        await setupFeatures()

        await serviceManager.register(services)

        await state.start()
    }

    func setupFeatures() async {
        await features.append(Onboarding.Feature(self))
        await features.append(AppSettings.Feature(self))
        await features.append(Authorization.Feature(self))
        // murray: registration
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
extension AppContainer: Authorization.FeatureContainer {}
// murray: container conformance

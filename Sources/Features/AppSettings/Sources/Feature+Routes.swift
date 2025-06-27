//
//  Feature+Routes.swift
//  Onboarding
//
//  Created by Stefano Mondino on 17/06/25.
//

import Foundation
import Routes

extension Feature {
    func setupRoutes() async {
        let routeContainer = await dependencies.routeContainer()
        await routeContainer.register(for: Themes.RouteDefinition.self) { [self] definition in
            let viewModel = await Themes.ViewModelImplementation(useCase: unsafeResolve())
            return SwiftUINavigationRoute(identifier: definition.identifier) {
                Themes.ViewContents(viewModel: viewModel)
            }
        }
        await routeContainer.register(for: Router.Identifier.EntryPoint.self) { [self] definition in
            let viewModel = await Themes.ViewModelImplementation(useCase: unsafeResolve())
            return SwiftUINavigationRoute(identifier: definition.identifier) {
                Themes.ViewContents(viewModel: viewModel)
            }
        }
    }
}

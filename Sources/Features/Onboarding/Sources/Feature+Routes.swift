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
        await routeContainer.register(for: OnboardingRouteDefinition.self) { _ in
            let viewModel = PermissionViewModelImplementation()
            return SwiftUINavigationRoute {
                PermissionView(viewModel: viewModel)
            }
        }
    }
}

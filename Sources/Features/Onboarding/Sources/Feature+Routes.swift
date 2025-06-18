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
        await routeContainer.register(for: OnboardingRouteDefinition.self) { definition in
            SwiftUINavigationRoute(identifier: "Inizio") {
                OnboardingView(viewModel: OnboardingView.ViewModel(message: definition.message))
            }
        }
    }
}

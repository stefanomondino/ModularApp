//
//  Router+SwiftUI.swift
//  Navi
//
//  Created by Stefano Mondino on 19/03/25.
//

import Foundation
import SwiftUI

public extension EnvironmentValues {
    @Entry var router: Router?
}

public protocol SwiftUIRoute: Route, Sendable {
    var view: @MainActor @Sendable () -> AnyView { get }
}

extension Router {
    struct NavigationPath<NavigationRoute: SwiftUIRoute>: Hashable, Identifiable {
        static func == (lhs: Router.NavigationPath<NavigationRoute>, rhs: Router.NavigationPath<NavigationRoute>) -> Bool {
            lhs.routeDefinition.identifier == rhs.routeDefinition.identifier
        }

        func hash(into hasher: inout Hasher) {
            hasher.combine(routeDefinition.identifier)
        }

        let route: NavigationRoute
        let routeDefinition: RouteDefinition
        var id: String { routeDefinition.identifier }
        init?(router: Router, routeDefinition: RouteDefinition) async {
            guard let route = await router.resolve(routeDefinition) as? NavigationRoute else {
                return nil
            }
            self.routeDefinition = routeDefinition
            self.route = route
        }
    }
}

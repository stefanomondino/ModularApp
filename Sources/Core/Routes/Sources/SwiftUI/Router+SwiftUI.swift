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
    init(identifier: String,
         _ view: @MainActor @Sendable @escaping () -> any View)
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
            guard let route = await router.resolve(routeDefinition) else {
                return nil
            }
            self.routeDefinition = routeDefinition
            switch route {
            case let navigationRoute as NavigationRoute:
                self.route = navigationRoute
            case let uiKit as UIKitRoute:
                guard uiKit.presentationMode.swiftUIType == NavigationRoute.self,
                      let viewController = await uiKit.createViewController()
                else {
                    return nil
                }
                self.route = NavigationRoute(identifier: UUID().uuidString) {
                    ViewControllerWrapper(viewController: viewController)
                }
            default: return nil
            }
        }
    }
}

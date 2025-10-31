//
//  Router+NavigationStack.swift
//  Navi
//
//  Created by Stefano Mondino on 21/03/25.
//

import Foundation
import SwiftUI

private struct NavigationRouterWrapper: ViewModifier {
    @Environment(\.router) var router
    func body(content: Content) -> some View {
        if let router {
            content.modifier(Router.NavigationStackModifier(router: router))
        }
    }
}

public extension View {
    func navigationStack(router: Router) -> some View {
        modifier(Router.NavigationStackModifier(router: router))
    }

    func navigationStack() -> some View {
        modifier(NavigationRouterWrapper())
    }
}

extension Router {
    struct NavigationStackModifier: ViewModifier {
        var router: Router
        @State var path: SwiftUI.NavigationPath = .init()
        @Environment(\.dismiss) var dismiss
        func body(content: Content) -> some View {
            NavigationStack(path: $path) {
                content
                    .modal()
                    .navigationDestination(for: NavigationPath<SwiftUINavigationRoute>.self) { path in
                        path.route.view()
                            .environment(\.router, router)
                    }
                    .uiKitNavigation()
                    .environment(\.router, router)
            }
            .task {
                for await route in self.router.definitionStream {
                    if let path = await NavigationPath<SwiftUINavigationRoute>(router: router, routeDefinition: route) {
                        self.path.append(path)
                    }
                    if let back = route as? BackRouteDefinition {
                        switch back.backType {
                        case .single:
                            guard !self.path.isEmpty else { return }
                            self.path.removeLast()
                        case .identifier:
                            while self.path.isEmpty == false {
                                self.path = .init()
                            }
                        case .root:
                            self.path = .init()
                        case let .count(count):
                            guard self.path.count >= count else { return }
                            self.path.removeLast(count)
                        }
                    }
                }
            }
        }
    }
}

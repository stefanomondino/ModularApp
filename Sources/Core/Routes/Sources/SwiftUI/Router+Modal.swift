//
//  Router+Modal.swift
//  Navi
//
//  Created by Stefano Mondino on 21/03/25.
//

import Foundation
import SwiftUI

public struct SwiftUIModalRoute: SwiftUIRoute, RouteDefinition {
    public let identifier: String = UUID().uuidString

    public func isSameRoute(as _: any RouteDefinition) -> Bool {
        false
    }

    public let view: @MainActor @Sendable () -> AnyView
    public init(_ view: @MainActor @Sendable @escaping () -> any View) {
        self.view = { AnyView(view()) }
    }
}

public extension View {
    func modal() -> some View {
        modifier(Router.ModalModifier())
    }
}

extension Router {
    struct ModalModifier: ViewModifier {
        @Environment(\.router) var router
        @State var path: Router.NavigationPath<SwiftUIModalRoute>?

        func body(content: Content) -> some View {
            content
                .uiKitModal()
                .task {
                    guard let router else { return }
                    for await route in await router.definitionStream {
                        if let path = await Router.NavigationPath<SwiftUIModalRoute>(router: router, routeDefinition: route) {
                            self.path = path
                        }
                    }
                }
                .fullScreenCover(item: $path) { path in
                    if let router = router {
                        let internalRouter = Router(container: router.container, name: "Modal presentation")
                        path.route.view()
                            .ignoresSafeArea()
                            .modifier(DismissModifier())
                            .environment(\.router, internalRouter)
                    }
                }
        }
    }

    struct DismissModifier: ViewModifier {
        @Environment(\.dismiss) var dismiss
        @Environment(\.router) var router

        func body(content: Content) -> some View {
            content
                .task {
                    guard let router else { return }
                    for await route in await router.definitionStream {
                        if route is BackRouteDefinition {
                            dismiss()
                        }
                    }
                }
        }
    }
}

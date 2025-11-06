//
//  Router+Restart.swift
//  Routes
//
//  Created by Stefano Mondino on 04/11/25.
//

import Foundation
import SwiftUI

struct RestartRouteModifier: ViewModifier {
    @Environment(\.router) private var router
    @Environment(\.colorScheme) var colorScheme
    @State private var restartRoute: SwiftUIRestartRoute?
    func body(content: Content) -> some View {
        ZStack {
            content.task {
                guard let router else { return }
                for await definition in router.definitionStream {
                    if let route = await router.resolve(definition) as? SwiftUIRestartRoute {
                        restartRoute = route
                    }
                }
            }
            if let restartRoute {
                AnyView(restartRoute.view())
            }
        }
    }
}

public extension View {
    func restartable() -> some View {
        modifier(RestartRouteModifier())
    }
}

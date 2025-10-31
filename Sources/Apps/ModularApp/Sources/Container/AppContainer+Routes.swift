//
//  AppContainer+Routes.swift
//  ModularApp
//
//  Created by Stefano Mondino on 17/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//
import Routes
import SwiftUI

extension AppContainer {
    func setupRoutes() async {
        await routeContainer.register(for: NavigationRouteDefinition.self) { _ in
            SwiftUINavigationRoute {
                DummyView()
            }
        }
        await routeContainer.register(for: ModalRouteDefinition.self) { _ in
            SwiftUIModalRoute {
                DummyView().navigationStack()
            }
        }
        await routeContainer.register(for: WebRouteDefinition.self) { definition in
            SafariRoute(url: definition.url)
        }
    }
}

struct DummyView: View {
    @State var viewModel: String = "Dummy View"
    @Environment(\.router) var router
    var body: some View {
        Text("Navigation Route - click me to go back")
            .onTapGesture {
                router?.send(BackRouteDefinition())
            }
    }
}

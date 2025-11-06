//
//  HomeView.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 04/11/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import Foundation
import Routes
import SwiftUI
import DesignSystem

struct HomeView: View {
    @Environment(Design.self) var design
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        ZStack {
            Design.AppColor.primary.swiftUIColor.ignoresSafeArea()
                .ignoresSafeArea()
            VStack {
                Text("Home View")
                Text("Color: \(colorScheme == .dark ? "Dark" : "Light")")
            }
        }
    }
}

struct HomeRouteDefinition: RouteDefinition, Equatable {
    let identifier: String = "home"
}

extension Router.Identifier {
    static func home() -> Self { .init(HomeRouteDefinition()) }
}

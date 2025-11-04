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

struct HomeView: View {
    var body: some View {
        ZStack {
            Color.blue.ignoresSafeArea()
            Text("Home View")
        }
    }
}

struct HomeRouteDefinition: RouteDefinition, Equatable {
    let identifier: String = "home"
}

extension Router.Identifier {
    static func home() -> Self { .init(HomeRouteDefinition()) }
}

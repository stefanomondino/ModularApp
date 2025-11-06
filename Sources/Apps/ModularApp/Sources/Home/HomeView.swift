//
//  HomeView.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 04/11/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DesignSystem
import Foundation
import Routes
import SwiftUI
import Images
struct HomeView: View {
    @Environment(Design.self) var design
    @Environment(\.colorScheme) var colorScheme
    @State private var seed = UUID()
    var body: some View {
        ZStack {

            Color.clear
            VStack {
                Text("Home View")
                Text("Color: \(colorScheme == .dark ? "Dark" : "Light")")
            }
        }.background {
            RemoteImage(URL(string: "https://picsum.photos/1080/1920?t=\(seed)")) {
                $0.view.resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .overlay {
                        Color.black.opacity(0.3).ignoresSafeArea()
                    }
                    .fade(if: $0.isDownloaded)
            }
        }
        .background {
                        Design.AppColor.primary.swiftUIColor.ignoresSafeArea()
                            .ignoresSafeArea()
        }
        .onTapGesture {
            seed = .init()
        }
    }
}

struct HomeRouteDefinition: RouteDefinition, Equatable {
    let identifier: String = "home"
}

extension Router.Identifier {
    static func home() -> Self { .init(HomeRouteDefinition()) }
}

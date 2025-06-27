//
//  ThemesView.swift
//  AppSettings
//
//  Created by Stefano Mondino on 24/06/25.
//
import DesignSystem
import Foundation
import Routes
import Streams
import SwiftUI

enum Themes {}

extension Themes {
    struct RouteDefinition: Routes.RouteDefinition, Equatable {
        var identifier: String { "themes.list" }
    }
}

extension Themes {
    struct ViewContents: View {
        @State var viewModel: ThemesSceneViewModel
        @Environment(\.design) var design: Design
        init(viewModel: ThemesSceneViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            VStack(spacing: design.value.get(.sidePadding(2)).doubleValue) {
                HStack {
                    TextField("Search themes",
                              text: .init(get: { viewModel.queryString },
                                          set: { viewModel.query($0) }))
                }
                .padding(.horizontal, .sidePadding(2))
                ScrollView {
                    LazyVStack(spacing: design.value.get(.sidePadding(2)).doubleValue) {
                        ForEach(viewModel.items, id: \.id) { item in
                            Card(viewModel: item)
                                .onTapGesture {
                                    viewModel.select(item)
                                }
                        }
                    }
                    .padding(.sidePadding(2))
                }
            }
            .background {
                design.color.background.swiftUIColor.ignoresSafeArea()
            }
        }
    }
}

// #Preview(traits: .design()) {
//    Themes.ViewContents(viewModel: ThemesViewModelMock {
//        $0.queryString = ""
//        $0.items = (0 ..< 10).map { index in
//            ThemeItemViewModelMock {
//                $0.id = "theme-\(index)"
//                $0.title = "Theme \(index + 1)"
//                $0.colors = ["#FF5733", "#33FF57", "#3357FF", "#FF3357", "#5733FF"].shuffled()
//            }
//        }
//    })
// }

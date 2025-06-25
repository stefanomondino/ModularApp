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

// sourcery: AutoMockable
@MainActor protocol ThemesViewModel {
    var items: [ThemeItemViewModel] { get }
    var queryString: String { get }
    func query(_ query: String)
}
// sourcery: AutoMockable
protocol ThemeItemViewModel {
    var id: String { get }
    var title: String { get }
    var colors: [String] { get }
}

enum Themes {}

extension Themes {
    struct RouteDefinition: Routes.RouteDefinition, Equatable {
        var identifier: String { "themes.list" }
    }
}

extension Themes {
    struct ViewContents: View {
        @State var viewModel: ThemesViewModel
        @Environment(\.design) var design: Design
        init(viewModel: ThemesViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            VStack {
                TextField("Search themes",
                          text: .init(get: { viewModel.queryString },
                                      set: { viewModel.query($0) }))
                    .padding(.horizontal, 16)
                ScrollView {
                    ForEach(viewModel.items, id: \.id) { item in
                        Card(viewModel: item)
                    }
                    .padding(16)
                }
            }
        }
    }

    struct Card: View {
        @State var viewModel: ThemeItemViewModel
        @Environment(\.design) var design: Design
        init(viewModel: ThemeItemViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            ZStack(alignment: .bottomLeading) {
                HStack(spacing: 0) {
                    ForEach(viewModel.colors, id: \.self) { color in
                        color.swiftUIColor
                    }
                }
                .aspectRatio(16 / 9, contentMode: .fill)
                Text(viewModel.title)
                    .typography(.h1, dynamic: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
                    .padding(.sidePadding(2))
                    .background {
                        design.color.get(.background)
                            .swiftUIColor
                            .opacity(0.2)
                    }
            }

            .background(.background)
            .cornerRadius(.cornerRadius(1))
            .clipped()
        }
    }
}

extension Themes {
    @Observable class ViewModel: ThemesViewModel {
        var items: [ThemeItemViewModel] = []
        private let queryProperty = Property("")

        var queryString: String = "" {
            didSet {
                Task { await queryProperty.send(queryString) }
            }
        }

        let useCase: ThemesUseCase

        init(useCase: ThemesUseCase) {
            self.useCase = useCase
//            queryString.flatMap { query in
//                useCase.availableThemes()
//            }.sink { items in
//                self.items = items.map { theme in
//                    ThemeItemViewModelMock {
//                        $0.id = theme.id
//                        $0.title = theme.title
//                    }
//            }
            Task { @MainActor in
                let themes = await useCase.availableThemes()
                self.items = themes.map { theme in
                    ThemeItemViewModelMock {
                        $0.id = theme.id
                        $0.title = theme.text
                        $0.colors = theme.colors
                    }
                }
            }
        }

        func query(_ query: String) {
            queryString = query
        }
    }
}

protocol ThemesUseCase: Sendable {
    func availableThemes() async -> [Theme]
    func update(theme: Theme) async
}

extension Themes {
    final actor UseCase: ThemesUseCase {
        let theme: ThemeRepository
        init(theme: ThemeRepository) {
            self.theme = theme
        }

        func availableThemes() async -> [Theme] {
            do {
                return try await theme.fetchThemes(query: "green")
            } catch {
                return []
            }
        }

        func update(theme _: Theme) async {}
    }
}

#Preview(traits: .design()) {
    Themes.ViewContents(viewModel: ThemesViewModelMock {
        $0.queryString = ""
        $0.items = (0 ..< 10).map { index in
            ThemeItemViewModelMock {
                $0.id = "theme-\(index)"
                $0.title = "Theme \(index + 1)"
                $0.colors = ["#FF5733", "#33FF57", "#3357FF", "#FF3357", "#5733FF"].shuffled()
            }
        }
    })
}

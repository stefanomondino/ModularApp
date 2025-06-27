//
//  ThemesViewModel.swift
//  AppSettings
//
//  Created by Stefano Mondino on 25/06/25.
//

import AsyncAlgorithms
import DesignSystem
import Streams
import SwiftUI

// sourcery: AutoMockable
@MainActor protocol ThemesSceneViewModel {
    var items: [ThemeItemViewModel] { get }
    var queryString: String { get }
    func query(_ query: String)
    func select(_ item: ThemeItemViewModel)
}

extension Themes {
    @Observable class ViewModelImplementation: ThemesSceneViewModel {
        var items: [ThemeItemViewModel] = []
        private let bag = TaskBag()
        private let queryProperty = Property("")

        var queryString: String = "" {
            didSet {
                Task { await queryProperty.send(queryString) }
            }
        }

        let useCase: ThemesUseCase

        init(useCase: ThemesUseCase) {
            self.useCase = useCase
            queryProperty.flatMapLatest { query in
                AsyncStream {
                    await useCase.availableThemes(query: query)
                }
            }
            .sink { @MainActor [weak self] themes in
                self?.items = themes
            }
            .store(in: bag)

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
                for await query in queryProperty {
                    let themes = await useCase.availableThemes(query: query)
                    self.items = themes.map { theme in
                        theme
                    }
                }
            }
        }

        func query(_ query: String) {
            queryString = query
        }

        func select(_ item: ThemeItemViewModel) {
            Task {
                await useCase.update(theme: item.theme)
            }
        }
    }
}

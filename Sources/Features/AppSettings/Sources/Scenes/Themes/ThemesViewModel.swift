//
//  ThemesViewModel.swift
//  AppSettings
//
//  Created by Stefano Mondino on 25/06/25.
//

import AsyncAlgorithms
import DesignSystem
import Observation
import Streams
import SwiftUI

// sourcery: AutoMockable
@MainActor protocol ThemesSceneViewModel: Observation.Observable, AnyObject {
    var items: [ThemeItemViewModel] { get }
    var queryString: String { get set }
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
            queryProperty
                .removeDuplicates()
                .debounce(for: .milliseconds(500))
                .flatMapLatest { query in
                    AsyncStream {
                        await useCase.availableThemes(query: query)
                    }
                }
                .sink { @MainActor [weak self] themes in
                    self?.items = themes
                }
                .store(in: bag)

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

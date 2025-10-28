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
    var query: Property<String> { get }
    func select(_ item: ThemeItemViewModel)
}

extension Themes {
    @Observable class ViewModelImplementation: ThemesSceneViewModel {
        var items: [ThemeItemViewModel] = []
        private let bag = TaskBag()
        let query = Property("")

        let useCase: ThemesUseCase

        init(useCase: ThemesUseCase) {
            self.useCase = useCase
            query
                .removeDuplicates()
                .debounce(for: .milliseconds(500))
                .flatMapLatest { query in
                    AsyncStream {
                        await useCase.availableThemes(query: query)
                    }
                }
                .sink { @MainActor [weak self] themes in
                    withAnimation {
                        self?.items = themes
                    }
                }
                .store(in: bag)

//            Task { @MainActor in
//                for await query in queryProperty {
//                    let themes = await useCase.availableThemes(query: query)
//                    self.items = themes.map { theme in
//                        theme
//                    }
//                }
//            }
        }

        func select(_ item: ThemeItemViewModel) {
            Task {
                await useCase.update(theme: item.theme)
            }
        }
    }
}

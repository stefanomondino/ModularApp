//
//  ThemesUseCase.swift
//  AppSettings
//
//  Created by Stefano Mondino on 25/06/25.
//

import DesignSystem
import Foundation

// sourcery: AutoMockable
protocol ThemesUseCase: Sendable {
    func availableThemes(query: String) async -> [Theme]
    func update(theme: Theme) async
}

extension Themes {
    final actor UseCase: ThemesUseCase {
        let theme: ThemeRepository
        let design: Design
        init(theme: ThemeRepository,
             design: Design) {
            self.theme = theme
            self.design = design
        }

        func availableThemes(query: String) async -> [Theme] {
            do {
                return try await theme.fetchThemes(query: query)
            } catch {
                return []
            }
        }

        func update(theme: Theme) async {
            for (key, color) in zip([Color.Key.accent, .primary, .secondary, .background], theme.colors) {
                await design.color.register(for: key) { color }
            }
        }
    }
}

//
//  Feature+UseCases.swift
//  AppSettingsTests
//
//  Created by Stefano Mondino on 24/06/25.
//

import Foundation
import Routes

extension Feature {
    func setupUseCases() async {
        await register(for: ThemesUseCase.self) { [self] in
            await Themes.UseCase(theme: unsafeResolve(), design: unsafeResolve())
        }
    }
}

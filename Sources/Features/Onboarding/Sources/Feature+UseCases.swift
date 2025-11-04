//
//  Feature+UseCases.swift
//  Onboarding
//
//  Created by Stefano Mondino on 17/06/25.
//

import Foundation
import Routes

extension Feature {
    func setupUseCases() async {
        await register(for: PermissionsUseCase.self, scope: .singleton) { [self] in
            await PermissionsUseCaseImplementation(permissions: unsafeResolve())
        }

        // murray: registration
    }
}

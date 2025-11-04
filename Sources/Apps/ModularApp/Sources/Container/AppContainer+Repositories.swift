//
//  AppContainer+Repositories.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 04/11/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DependencyContainer
import Foundation
import Onboarding

extension AppContainer {
    func setupRepositories() async {
        await register(for: PermissionsRepository.self, scope: .singleton) { [self] in
            await PermissionsRepositoryImplementation(permissions: [.locationWhenInUse(unsafeResolve())])
        }
    }
}

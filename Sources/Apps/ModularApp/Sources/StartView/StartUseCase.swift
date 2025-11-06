//
//  StartUseCase.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 04/11/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import Foundation
import Onboarding
import Routes

// sourcery: AutoMockable
protocol StartUseCase: Sendable {
    func destination() async -> Router.Identifier
}

final class StartUseCaseImplementation: StartUseCase {
    let permissions: PermissionsRepository

    init(permissions: PermissionsRepository) {
        self.permissions = permissions
    }

    func destination() async -> Router.Identifier {
        let permissions = await permissions.permissionsToAsk()
        return permissions.isEmpty ? .home() : .onboarding()
    }
}

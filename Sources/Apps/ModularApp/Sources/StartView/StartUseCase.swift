//
//  StartUseCase.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 04/11/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import Foundation
import Onboarding

// sourcery: AutoMockable
protocol StartUseCase: Sendable {
    func destination() async -> StartDestination
}

enum StartDestination {
    case splash
    case login
    case onboarding
    case home
}

final class StartUseCaseImplementation: StartUseCase {
    let permissions: PermissionsRepository

    init(permissions: PermissionsRepository) {
        self.permissions = permissions
    }

    func destination() async -> StartDestination {
        let permissions = await permissions.permissionsToAsk()
        return permissions.isEmpty ? .home : .onboarding
    }
}

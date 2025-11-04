//
//  PermissionsUseCase.swift
//  Onboarding
//
//  Created by Stefano Mondino on 04/11/25.
//

import DataStructures
import Foundation

// sourcery: AutoMockable
public protocol PermissionsUseCase: Sendable {
    func nextPermission() async -> Permission?
}

final class PermissionsUseCaseImplementation: PermissionsUseCase {
    private let permissions: PermissionsRepository
    init(permissions: PermissionsRepository) {
        self.permissions = permissions
    }

    func nextPermission() async -> Permission? {
        await permissions.permissionsToAsk().first
    }
}

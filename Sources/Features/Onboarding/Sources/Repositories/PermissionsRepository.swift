//
//  PermissionsRepository.swift
//  Onboarding
//
//  Created by Stefano Mondino on 04/11/25.
//

import DataStructures
import Foundation

public protocol PermissionsRepository: Sendable {
    var permissions: [Permission] { get }
    func permissionsToAsk() async -> [Permission]
}

public final class PermissionsRepositoryImplementation: PermissionsRepository {
    public let permissions: [DataStructures.Permission]

    public init(permissions: [Permission]) {
        self.permissions = permissions
    }

    public func permissionsToAsk() async -> [Permission] {
        var permissionsToAsk: [Permission] = []
        for permission in permissions {
            if await permission.shouldAsk() {
                permissionsToAsk.append(permission)
            }
        }
        return permissionsToAsk
    }
}

//
//  PermissionViewModel.swift
//  Onboarding
//
//  Created by Stefano Mondino on 04/11/25.
//
import DataStructures
import Foundation
import Observation
import Routes

// sourcery: AutoMockable
@MainActor protocol PermissionViewModel {
    func activate()
    func start() async
    var title: String { get }
}

@Observable final class PermissionViewModelImplementation: PermissionViewModel {
    let title: String = "Permission"
    var permission: Permission?
    let permissionsUseCase: PermissionsUseCase
    let router: Router
    init(router: Router,
         permissionsUseCase: PermissionsUseCase) async {
        self.router = router
        self.permissionsUseCase = permissionsUseCase
    }

    func start() async {
        permission = await permissionsUseCase.nextPermission()
        if permission == nil {
            router.send(.restart())
        }
    }

    func activate() {
        Task { @MainActor in
            _ = try await permission?.ask()
            await start()
        }
    }
}

//
//  StartViewModel.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 03/11/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import Foundation
import Onboarding
import Routes

@Observable @MainActor final class StartViewModel {
    let router: Router
    let identifier = UUID()
    let useCase: StartUseCase

    init(router: Router,
         useCase: StartUseCase) async {
        self.router = router
        self.useCase = useCase
    }

    func start() async {
        await router.send(useCase.destination())
    }
}

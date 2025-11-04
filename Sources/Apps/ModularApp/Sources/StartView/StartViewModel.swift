//
//  StartViewModel.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 03/11/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import Foundation
import Routes
import Onboarding

@Observable @MainActor final class StartViewModel {
    let router: Router
    init(router: Router) async {
        self.router = router
    }

    func goToAppSettings() {
        if true {
            router.send(.onboarding())
        }
    }
}

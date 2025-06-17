//
//  AppState.swift
//  ModularApp
//
//  Created by Stefano Mondino on 17/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DataStructures
import Observation
import Routes

@Observable final class AppState {
    var isConfigured: Bool = false
    let router: Router

    init(router: Router) {
        self.router = router
    }
}

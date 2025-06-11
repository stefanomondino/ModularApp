//
//  AppContainer.swift
//  ModularApp
//
//  Created by Stefano Mondino on 11/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DependencyContainer
import DesignSystem

actor AppContainer: DependencyContainer {
    let container = ObjectContainer()

    @MainActor func setup() {
        Design.shared.setup()
    }
}

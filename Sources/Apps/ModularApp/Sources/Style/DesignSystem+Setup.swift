//
//  DesignSystem+Setup.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 11/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DesignSystem
import Foundation

extension Design {
    @MainActor func setup() {
        setupTypography()
        setupColor()
        setupValues()
    }
}

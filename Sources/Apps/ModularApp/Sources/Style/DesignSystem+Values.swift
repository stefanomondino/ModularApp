//
//  DesignSystem+Values.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 11/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DesignSystem
import Foundation
import SwiftUI

extension Design {
    @MainActor func setupValues() {
        value.cornerRadius = 8

        let baseMultiplier: CGFloat = 8
        for multiplier in [0.25, 0.5, 1, 2, 3, 4] {
            value.register(for: .sidePadding(multiplier)) { NumberValue(doubleValue: baseMultiplier * multiplier) }
            value.register(for: .cornerRadius(multiplier)) { NumberValue(doubleValue: baseMultiplier * multiplier) }
        }
    }
}

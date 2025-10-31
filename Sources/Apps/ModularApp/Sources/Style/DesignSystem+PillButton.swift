//
//  DesignSystem+PillButton.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 11/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import Components
import DesignSystem
import Foundation
import SwiftUI

extension Design {
    @MainActor func setupPillButton() {
        pillButton.register(for: .standard) { [self] in
            PillButton.Style(foregroundColor: color.primary,
                             backgroundColor: color.background,
                             showArrow: false)
        }
        pillButton.register(for: .secondary) { [self] in
            PillButton.Style(foregroundColor: color.background,
                             backgroundColor: color.primary,
                             showArrow: true)
        }
    }
}

extension PillButton.Key {
    static var secondary: Self { "secondary" }
}

#Preview(traits: .design(.app)) {
    @Previewable @Environment(\.design) var design
    VStack(spacing: 16) {
        ForEach([PillButton.Key.standard, .secondary], id: \.self) {
            PillButton("Test", style: $0)
        }
    }
}

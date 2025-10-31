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
        pill.register(for: .standard) { [self] in
            Pill.Style(foregroundColor: color.primary,
                       backgroundColor: color.background,
                       showArrow: false)
        }
        pill.register(for: .secondary) { [self] in
            Pill.Style(foregroundColor: color.background,
                       backgroundColor: color.primary,
                       showArrow: true)
        }
        pill.register(for: .outline) { [self] in
            Pill.Style(foregroundColor: color.primary,
                       backgroundColor: SwiftUI.Color.clear,
                       showArrow: false)
        }
    }
}

extension Pill.Key {
    static var secondary: Self { "secondary" }
    static var outline: Self { "outline" }
}

#Preview(traits: .design(.app)) {
    @Previewable @Environment(\.design) var design
    VStack(spacing: 16) {
        ForEach([Pill.Key.standard, .secondary, .outline], id: \.self) {
            Pill.Button("Test", style: $0)
            Pill.Button("Hanno osato cervare l'ucciso del re", style: $0)
        }
    }
}

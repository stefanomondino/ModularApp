//
//  DesignSystem+Color.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 11/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DesignSystem
import Foundation
import SwiftUI

extension Design {
    @MainActor func setupColor() {
        let design = Design.shared
        design.color
            .register(for: .primary) { Color.green }
            .register(for: .background) { Color.red }
            .register(for: .secondary, type: ColorConvertible.self) {
                ["#ffcc00", "#00ffcc"]
//                DesignSystem.LinearGradient(colors: [.red, Color.yellow],
//                                            startPoint: .leading,
//                                            endPoint: .trailing)
            }
    }
}

extension Color {
    static var green: ColorConvertible { "#00FF00" }
    static var red: ColorConvertible { "#FF0000" }
    static var blue: ColorConvertible { "#0000FF" }
    static var yellow: ColorConvertible { "#FFFF00" }
}

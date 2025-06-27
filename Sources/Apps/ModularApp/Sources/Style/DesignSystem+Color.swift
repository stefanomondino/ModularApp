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
    typealias AppColor = ModularAppAsset.Colors

    @MainActor func setupColor() {
        color
            .register(for: .primary) { AppColor.primary }
            .register(for: .app) { "#56F30E" }
            .register(for: .background) {
                DesignSystem.RadialGradient(colors: [AppColor.background, SwiftUI.Color.blue],
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 300)
            }
            .register(for: .secondary, type: ColorConvertible.self) {
                DesignSystem.RadialGradient(colors: [UIColor.red, UIColor.green],
                                            center: .center,
                                            startRadius: 0,
                                            endRadius: 100)
            }
    }
}

extension DesignSystem.Color.Key {
    static var app: Self { "app" }
}

extension ModularAppColors: ColorConvertible {
    public var hex: String {
        swiftUIColor.hex
    }
}

// extension Color {
//    static var green: ColorConvertible { "#00FF00" }
//    static var red: ColorConvertible { "#FF0000" }
//    static var blue: ColorConvertible { "#0000FF" }
//    static var yellow: ColorConvertible { "#FFFF00" }
// }

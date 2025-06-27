//
//  ColorConvertible.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import Foundation
import SwiftUI

public protocol ColorConvertible: Sendable {
    var swiftUIColor: SwiftUI.Color { get }
//    @ViewBuilder func swiftUILinearGradient() -> SwiftUI.LinearGradient?
//    @ViewBuilder func swiftUIRadialGradient() -> SwiftUI.RadialGradient?
    var hex: String { get }
}

extension SwiftUI.Color: ColorConvertible {
    public var swiftUIColor: SwiftUI.Color { self }
    public var hex: String { UIColor(self).hex }
}

public extension ColorConvertible where Self: CustomStringConvertible {
    var hex: String { description }
    func withAlpha(_ alpha: UInt) -> String {
        let value = min(alpha, 100) * 255 / 100
        let hex = String(format: "%02X", value)
        let stringValue: String = description
        return "#\(stringValue.replacingOccurrences(of: "#", with: "").prefix(6))\(hex)"
    }

    var stringValue: String {
        description
    }
}

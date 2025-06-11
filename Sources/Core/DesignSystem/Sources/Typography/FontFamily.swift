//
//  FontFamily.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//
import Foundation
import class UIKit.UIFont

public typealias Font = UIFont

public struct FontFamily: Sendable {
    public struct Properties: Sendable {
        public let weight: FontWeight
        public let size: FontSize
        public let dynamic: Bool

        public init(weight: FontWeight, size: FontSize, dynamic: Bool = true) {
            self.weight = weight
            self.size = size
            self.dynamic = dynamic
        }
    }

    let font: @Sendable (Properties) -> Font
    public init(_ font: @Sendable @escaping (Properties) -> Font) {
        self.font = font
    }
}

public extension FontFamily {
    static var system: FontFamily {
        FontFamily { properties in
            .systemFont(ofSize: properties.size.scaledValue(properties.dynamic),
                        weight: properties.weight.uiValue)
        }
    }

    static var code: FontFamily {
        FontFamily { properties in
            .monospacedSystemFont(ofSize: properties.size.scaledValue(properties.dynamic),
                                  weight: properties.weight.uiValue)
        }
    }
}

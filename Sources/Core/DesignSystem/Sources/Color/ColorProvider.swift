//
//  ColorProvider.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import DataStructures
import DependencyContainer
import Foundation
import SwiftUI

public extension Color {
    struct Key: ExtensibleIdentifierType, ExpressibleByStringInterpolation {
        public let value: String
        public init(_ value: String) {
            self.value = value
        }
    }

    @Observable
    final class Provider: DesignValueProvider {
        public var storage: Storage<Color.Key> = .init()
        public let defaultValue: ColorConvertible
        public init(defaultValue: ColorConvertible = "#000000") {
            self.defaultValue = defaultValue
        }
    }
}

public extension Color.Key {
    static var primary: Self { "primary" }
    static var secondary: Self { "secondary" }
    static var background: Self { "background" }
    static var accent: Self { "accent" }
}

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
    @dynamicMemberLookup
    @MainActor final class Provider: MainActorProvider {
        public var provider: [Color.Key: () -> Any] = [:]
        public typealias Key = Color.Key
        let defaultValue: ColorConvertible

        public init(defaultValue: ColorConvertible = "#000000") {
            self.defaultValue = defaultValue
        }

        public subscript(dynamicMember key: Key) -> ColorConvertible {
            resolve(key, default: defaultValue)
        }

        public func get(_ key: Key) -> ColorConvertible {
            resolve(key, default: defaultValue)
        }
    }
}

public extension Color.Provider.Key {
    static var primary: Self { "primary" }
    static var secondary: Self { "secondary" }
    static var background: Self { "background" }
    static var accent: Self { "accent" }
}

//
//  TypographyProvider.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 10/06/25.
//

import DataStructures
import DependencyContainer
import Foundation

public extension Typography {
    struct Key: ExtensibleIdentifierType, ExpressibleByStringInterpolation {
        public let value: String
        public init(_ value: String) {
            self.value = value
        }
    }

    @Observable
    @dynamicMemberLookup
    @MainActor final class Provider: MainActorProvider {
        public var provider: [Typography.Key: () -> Any] = [:]
        public typealias Key = Typography.Key
        let defaultValue: Typography

        public init(defaultValue: Typography = Typography(family: .system,
                                                          size: 18)) {
            self.defaultValue = defaultValue
        }

        public subscript(dynamicMember key: Key) -> Typography {
            get {
                resolve(key, default: defaultValue)
            } set {
                register(for: key, callback: { newValue })
            }
        }

        public func get(_ key: Key) -> Typography {
            resolve(key, default: defaultValue)
        }
    }
}

public extension Typography.Key {
    static var h1: Self { "h1" }
    static var h2: Self { "h2" }
    static var body: Self { "body" }
}

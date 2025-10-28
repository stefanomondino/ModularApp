//
//  AssetProvider.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import DataStructures
import DependencyContainer
import Foundation
import SwiftUI

public protocol AssetConvertible: Sendable {
    var swiftUIImage: SwiftUI.Image { get }
    var uiKitImage: UIImage { get }
}

extension SwiftUI.Image: AssetConvertible {
    public var uiKitImage: UIImage { .init() }
    public var swiftUIImage: SwiftUI.Image { self }
}

extension UIImage: AssetConvertible {
    public var uiKitImage: UIImage { self }
    public var swiftUIImage: SwiftUI.Image { .init(uiImage: self) }
}

public extension Image {
    struct Key: ExtensibleIdentifierType, ExpressibleByStringInterpolation {
        public let value: String
        public init(_ value: String) {
            self.value = value
        }
    }

    @Observable
    final class Provider: DesignValueProvider {
        public var provider: [Image.Key: () -> Any] = [:]
        public let defaultValue: AssetConvertible
        public init(defaultValue: AssetConvertible = UIImage()) {
            self.defaultValue = defaultValue
        }
    }
}

public extension Image.Key {
    static var backIcon: Self { "backIcon" }
}

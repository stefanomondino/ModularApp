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

public struct Asset: Sendable {
    public let image: Image
    public init(_ image: Image = .init()) {
        self.image = image
    }
}

public extension SwiftUI.Image {
    init(_ asset: Asset) {
        self.init(uiImage: asset.image)
    }
}

public extension Asset {
    struct Key: ExtensibleIdentifierType, ExpressibleByStringInterpolation {
        public let value: String
        public init(_ value: String) {
            self.value = value
        }
    }

    @Observable
    final class Provider: DesignValueProvider {
        public var provider: [Asset.Key: () -> Any] = [:]
        public let defaultValue: Asset
        public init(defaultValue: Asset = .init()) {
            self.defaultValue = defaultValue
        }
    }
}

public extension Asset.Key {
    static var backIcon: Self { "backIcon" }
}

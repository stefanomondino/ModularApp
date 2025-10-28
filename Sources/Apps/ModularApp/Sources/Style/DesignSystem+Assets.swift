//
//  DesignSystem+Assets.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 11/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import AppSettings
import DesignSystem
import Foundation
import SwiftUI

extension Design {
    @MainActor func setupAssets() {
        asset.register(for: .backIcon) {
            ModularAppAsset.Assets.someImage
        }
        asset.register(for: .themeIcon) {
            ModularAppAsset.Assets.someImage
        }
    }
}

extension ModularAppImages: AssetConvertible {
    public var uiKitImage: UIImage {
        image
    }
}

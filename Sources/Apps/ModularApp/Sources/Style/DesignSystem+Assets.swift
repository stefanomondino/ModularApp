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
            Asset(ModularAppAsset.Assets.someImage.image)
        }
        asset.register(for: .themeIcon) {
            Asset(ModularAppAsset.Assets.someImage.image)
        }
    }
}

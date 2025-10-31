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
            UIImage()
        }
        asset.register(for: .themeIcon) {
            UIImage()
        }
    }
}

extension ModularAppImages: AssetConvertible {
    public var uiKitImage: UIImage {
        image
    }
}

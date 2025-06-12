//
//  DesignSystem+Typography.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 11/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DesignSystem
import Foundation

extension Design {
    @MainActor func setupTypography() {
        typography.h1 = Typography(family: .archivo, weight: .black, size: 24)
        typography.body = Typography(family: .archivo, weight: .ultralight, size: 24)
    }
}

public extension FontFamily {
    static var archivo: FontFamily {
        .init { properties in
            let font = switch properties.weight {
            case .black: ModularAppDevFontFamily.Archivo.black
            default: ModularAppDevFontFamily.Archivo.regular
            }
            return font.font(size: properties.size.scaledValue(properties.dynamic))
        }
    }
}

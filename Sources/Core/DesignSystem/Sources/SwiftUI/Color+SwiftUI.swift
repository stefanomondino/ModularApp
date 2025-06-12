//
//  Color+SwiftUI.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import Foundation
import SwiftUI

public extension View {
    @ViewBuilder
    func foregroundColor(_ color: ColorConvertible) -> some View {
        if let gradient = color.swiftUIGradient {
            overlay(gradient)
        } else {
            foregroundStyle(color.swiftUIColor)
        }
    }

    func foregroundColor(_ key: Color.Key, provider: Color.Provider) -> some View {
        foregroundColor(provider.get(key))
    }

    @ViewBuilder
    func backgroundColor(_ color: ColorConvertible) -> some View {
        if let gradient = color.swiftUIGradient {
            background(gradient)
        } else {
            backgroundStyle(color.swiftUIColor)
        }
    }

    func backgroundColor(_ key: Color.Key, provider: Color.Provider) -> some View {
        backgroundColor(provider.get(key))
    }
}

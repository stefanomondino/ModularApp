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

    func foregroundColor(_ key: Color.Key, provider: Color.Provider? = nil) -> some View {
        modifier(ForegroundColorModifier(key: key, provider: provider))
    }

    @ViewBuilder
    func backgroundColor(_ color: ColorConvertible) -> some View {
        if let gradient = color.swiftUIGradient {
            background(gradient)
        } else {
            background {
                color.swiftUIColor
            }
        }
    }

    func backgroundColor(_ key: Color.Key, provider: Color.Provider? = nil) -> some View {
        modifier(BackgroundColorModifier(key: key, provider: provider))
    }
}

struct BackgroundColorModifier: ViewModifier {
    @Environment(\.design) var design: Design
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.colorSchemeContrast) var colorSchemeContrast
    let key: Color.Key
    let provider: Color.Provider?
    func body(content: Content) -> some View {
        content.backgroundColor((provider ?? design.color).get(key))
    }
}

struct ForegroundColorModifier: ViewModifier {
    @Environment(\.design) var design: Design
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.colorSchemeContrast) var colorSchemeContrast
    let key: Color.Key
    let provider: Color.Provider?
    func body(content: Content) -> some View {
        content.foregroundColor((provider ?? design.color).get(key))
    }
}

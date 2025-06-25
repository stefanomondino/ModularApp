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
        switch color {
        case let linear as LinearGradient:
            overlay(alignment: .center) { linear.swiftUILinearGradient() }
                .mask(self)
        case let radial as RadialGradient:
            overlay(alignment: .center) { radial.swiftUIRadialGradient() }
                .mask(self)
        default: foregroundStyle(color.swiftUIColor)
        }
    }

    func foregroundColor(_ key: Color.Key, provider: Color.Provider? = nil) -> some View {
        modifier(ForegroundColorModifier(key: key, provider: provider))
    }

    @ViewBuilder
    func backgroundColor(_ color: ColorConvertible) -> some View {
        switch color {
        case let linear as LinearGradient:
            background(alignment: .center) { linear.swiftUILinearGradient() }

        case let radial as RadialGradient:
            background(alignment: .center) { radial.swiftUIRadialGradient() }

        default: background {
                color.swiftUIColor
            }
        }
    }

    func backgroundColor(_ key: Color.Key, provider: Color.Provider? = nil) -> some View {
        modifier(BackgroundColorModifier(key: key, provider: provider))
    }
}

extension ColorConvertible {
    @ViewBuilder func swiftUIView() -> some View {
        switch self {
        case let linear as LinearGradient:
            linear.swiftUILinearGradient()
        case let radial as RadialGradient:
            radial.swiftUIRadialGradient()
        default: swiftUIColor
        }
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

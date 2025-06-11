//
//  FontWeight.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import SwiftUI

public enum FontWeight: Sendable {
    case regular
    case bold
    case semibold
    case boldItalic
    case extrabold
    case extraboldItalic
    case heavy
    case black
    case medium
    case italic
    case light
    case ultralight
    case thin
    public var cssValue: String {
        switch self {
        case .regular: "normal"
        case .medium: "500"
        case .bold: "700"
        case .extrabold, .extraboldItalic: "800"
        case .black: "900"
        default: "normal"
        }
    }

    var uiValue: Font.Weight {
        switch self {
        case .regular: .regular
        case .bold: .bold
        case .boldItalic: .bold
        case .extrabold: .bold
        case .extraboldItalic: .bold
        case .light: .light
        case .medium: .medium
        case .italic: .medium
        case .semibold: .semibold
        case .black: .black
        case .heavy: .heavy
        case .thin: .thin
        case .ultralight: .ultraLight
        }
    }

    var swiftUIValue: SwiftUI.Font.Weight {
        switch self {
        case .regular: .regular
        case .bold: .bold
        case .boldItalic: .bold
        case .extrabold: .bold
        case .extraboldItalic: .bold
        case .light: .light
        case .medium: .medium
        case .italic: .medium
        case .semibold: .semibold
        case .black: .black
        case .heavy: .heavy
        case .thin: .thin
        case .ultralight: .ultraLight
        }
    }
}

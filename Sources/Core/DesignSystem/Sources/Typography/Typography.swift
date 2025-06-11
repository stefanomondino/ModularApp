//
//  Typography.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 10/06/25.
//
import DataStructures
import SwiftUI

public struct Typography: Sendable {
    public enum TextAlignment: Sendable {
        case leading
        case trailing
        case center
    }

    public enum UnderlineStyle: Sendable {
        case single
        case none
    }

    public var family: FontFamily
    public var weight: FontWeight
    public var size: FontSize
    public var letterSpacing: CGFloat
    public var numberOfLines: Int
    public var underlineStyle: UnderlineStyle?
    public var lineHeight: LineHeight
    public var baselineOffset: CGFloat
    public var textCase: Text.Case?
    public var italic: Self {
        var italic = self
        italic.weight = .italic
        return italic
    }

    @MainActor
    public func font(dynamic: Bool = true) -> Font {
        family.font(.init(weight: weight, size: size, dynamic: dynamic))
    }

    public init(family: FontFamily,
                weight: FontWeight = .regular,
                size: FontSize,
                letterSpacing: CGFloat = 0,
                numberOfLines: Int = 0,
                baselineOffset: CGFloat = 0,
                underlineStyle: UnderlineStyle? = nil,
                lineHeight: LineHeight = .relative(0),
                textCase: Text.Case? = nil) {
        self.family = family
        self.baselineOffset = baselineOffset
        self.weight = weight
        self.size = size
        self.letterSpacing = letterSpacing
        self.numberOfLines = numberOfLines
        self.underlineStyle = underlineStyle
        self.lineHeight = lineHeight
        self.textCase = textCase
    }
}

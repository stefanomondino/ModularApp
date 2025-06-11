//
//  LineHeight.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import Foundation

public enum LineHeight: Sendable {
    case absolute(CGFloat)
    case relative(CGFloat)

    public func value(fontSize: FontSize) -> CGFloat {
        switch self {
        case let .absolute(value): value
        case let .relative(multiplier): fontSize.value * multiplier
        }
    }

    public func relativeValue(fontSize: FontSize) -> CGFloat {
        switch self {
        case let .absolute(value): value / fontSize.value
        case let .relative(multiplier): multiplier
        }
    }
}

//
//  FontSize.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import Foundation

public struct FontSize: ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral, Sendable {
    public let value: Double
    public init(_ value: Double) {
        self.value = value
    }

    public init(floatLiteral value: Double) {
        self.value = value
    }

    public init(integerLiteral value: IntegerLiteralType) {
        self.value = Double(value)
    }
}

#if canImport(UIKit)
    import UIKit

    public extension FontSize {
        func scaledValue(_ dynamic: Bool) -> CGFloat {
            dynamic ? UIFontMetrics.default.scaledValue(for: value) : value
        }
    }
#else
    public extension FontSize {
        func scaledValue(_: Bool) -> CGFloat {
            value
        }
    }
#endif

//
//  Typography+SwiftUI.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import Foundation
import SwiftUI

public extension View {
    func typography(_ typography: Typography,
                    dynamic: Bool = true) -> some View {
        modifier(TypographyModifier(value: .value(typography),
                                    dynamic: dynamic,
                                    provider: nil))
    }

    func typography(_ key: Typography.Provider.Key,
                    dynamic: Bool = true,
                    provider: Typography.Provider? = nil) -> some View {
        modifier(TypographyModifier(value: .key(key),
                                    dynamic: dynamic,
                                    provider: provider))
    }
}

struct TypographyModifier: ViewModifier {
    @MainActor fileprivate enum AccessValue {
        case value(Typography)
        case key(Typography.Key)
        func extract(with provider: Typography.Provider) -> Typography {
            switch self {
            case let .value(value):
                return value
            case let .key(key):
                return provider.get(key)
            }
        }
    }

    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.design) var design: Design

    fileprivate let value: AccessValue
    fileprivate let dynamic: Bool
    fileprivate let provider: Typography.Provider?
    func body(content: Content) -> some View {
        let typography = value.extract(with: provider ?? design.typography)

        if #available(iOS 26.0, *) {
            return content
                .lineHeight(.multiple(factor: typography.lineHeight
                        .relativeValue(fontSize: typography.size)))
                .font(.init(typography.font(dynamic: dynamic) as CTFont))
                .textCase(typography.textCase)
        } else {
            return content
                .font(.init(typography.font(dynamic: dynamic) as CTFont))
                .textCase(typography.textCase)
                .lineSpacing(typography.lineHeight.value(fontSize: typography.size))
            // Fallback on earlier versions
        }
    }
}

#Preview(traits: .design(.baseTypography)) {
    Text("Ciao")
        .typography(.h1)
    Text("Welcome to our DesignSystem. Looks beautiful, right?")
        .typography(.h2)
        .multilineTextAlignment(.center)
}

public extension DesignPreviewModifier.Customization {
    static var baseTypography: Self {
        .init {
            $0.typography.h1 = Typography(
                family: .system,
                weight: .black,
                size: 48
            )
            $0.typography.h2 = Typography(
                family: .system,
                weight: .bold,
                size: 20,
                lineHeight: .relative(0.75)
            )
        }
    }
}

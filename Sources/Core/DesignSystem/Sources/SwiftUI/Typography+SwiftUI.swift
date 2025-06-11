//
//  Typography+SwiftUI.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import Foundation
import SwiftUI

public extension View {
    func typography(_ typography: Typography) -> some View {
        modifier(TypographyModifier(value: .value(typography), dynamic: true))
    }

    func typography(_ keyPath: KeyPath<Typography.Provider, Typography>,
                    provider: Typography.Provider) -> some View {
        typography(provider[keyPath: keyPath])
    }
}

struct TypographyModifier: ViewModifier {
    @MainActor enum AccessValue: Sendable {
        case value(Typography)
        case keyPath(KeyPath<Typography.Provider, Typography>)
        func extract(with design: Design) -> Typography {
            switch self {
            case let .value(value):
                return value
            case let .keyPath(keyPath):
                return design.typography[keyPath: keyPath]
            }
        }
    }

    @Environment(\.sizeCategory) var sizeCategory
    @Environment(\.design) var design: Design

    let value: AccessValue
    let dynamic: Bool

    func body(content: Content) -> some View {
        let typography = value.extract(with: design)
        return content
            .font(.init(typography.font(dynamic: dynamic) as CTFont))
    }
}

#Preview {
    Text("Ciao")
        .typography(.init(family: .system,
                          weight: .black,
                          size: 30))
}

//
//  PillButton.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import SwiftUI

public struct PillButton: View {
    let action: @Sendable () async -> Void
    let title: String
    let style: Style
    public init(
        _ title: String = "Button",
        style: Style,
        action: @Sendable @escaping @MainActor () async -> Void = {}
    ) {
        self.action = action
        self.title = title
        self.style = style
    }

    public var body: some View {
        Button(action: { Task {
                   await action()
               } },
               label: {
                   Text("Button")
               })
               .buttonStyle(style)
    }
}

public extension PillButton {
    struct Style: ButtonStyle {
        @Environment(\.isEnabled) var isEnabled: Bool

        public let foregroundColor: ColorConvertible
        public let backgroundColor: ColorConvertible
        public let showArrow: Bool

        public init(
            foregroundColor: ColorConvertible,
            backgroundColor: ColorConvertible,
            showArrow: Bool
        ) {
            self.foregroundColor = foregroundColor
            self.backgroundColor = backgroundColor
            self.showArrow = showArrow
        }

        public func makeBody(configuration: Configuration) -> some View {
            HStack(spacing: 8) {
                if configuration.isPressed {
                    Text("\(isEnabled ? "Enabled" : "Disabled")")

                } else {
                    configuration.label
                }
                if showArrow {
                    Image(systemName: "chevron.right")
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background { backgroundColor.swiftUIGradient }
            .foregroundColor(foregroundColor)
            .clipShape(Capsule())
        }
    }
}

#Preview(traits: .design(.baseTypography)) {
    @Previewable @Environment(\.design) var design
    VStack {
        PillButton(style: .init(foregroundColor: design.color.primary,
                                backgroundColor: design.color.secondary,
                                showArrow: true))
//        PillButton().disabled(true)
    }
}

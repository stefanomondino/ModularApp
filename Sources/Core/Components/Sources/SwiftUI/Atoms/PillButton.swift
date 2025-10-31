//
//  PillButton.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import DataStructures
import DependencyContainer
import DesignSystem
import SwiftUI

public extension Design {
    @MainActor var pill: Pill.Provider {
        resolve(default: .init())
    }
}

public enum Pill {}

public extension Pill {
    struct Key: ExtensibleIdentifierType, ExpressibleByStringInterpolation {
        public let value: String
        public init(_ value: String) {
            self.value = value
        }

        public static var standard: Self { .init("standard") }
    }

    @Observable
    final class Provider: DesignValueProvider {
        public var storage: Storage<Key> = .init()
        public let defaultValue: Style
        public init(defaultValue: Style = .init(foregroundColor: "#000000",
                                                backgroundColor: "#FFFFFF",
                                                showArrow: false)) {
            self.defaultValue = defaultValue
        }
    }
}

public extension Pill {
    struct Button<Label: View>: View {
        @Environment(\.design) var design
        let action: @Sendable () async -> Void
        let title: () -> Label
        let style: (Design) -> Style
        public init(_ title: String,
                    style: Style,
                    action: @Sendable @escaping @MainActor () async -> Void = {}) where Label == Text {
            self.action = action
            self.title = { Text(title) }
            self.style = { _ in style }
        }

        public init(_ title: String,
                    style key: Key,
                    action: @Sendable @escaping @MainActor () async -> Void = {}) where Label == Text {
            self.action = action
            self.title = { Text(title) }
            style = { $0.pill.get(key) }
        }

        public var body: some View {
            SwiftUI.Button(action: { Task {
                               await action()
                           } },
                           label: { title() })
                .buttonStyle(style(design))
        }
    }
}

public extension Pill {
    struct Style: ButtonStyle {
        @Environment(\.isEnabled) var isEnabled: Bool

        public let foregroundColor: ColorConvertible
        public let backgroundColor: ColorConvertible
        public let showArrow: Bool

        public init(foregroundColor: ColorConvertible,
                    backgroundColor: ColorConvertible,
                    showArrow: Bool) {
            self.foregroundColor = foregroundColor
            self.backgroundColor = backgroundColor
            self.showArrow = showArrow
        }

        public func makeBody(configuration: Configuration) -> some View {
            HStack(spacing: 8) {
                configuration.label
                if showArrow {
                    SwiftUI.Image(systemName: "chevron.right")
                }
            }
            .foregroundColor(foregroundColor)
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .backgroundColor(backgroundColor)
            .clipShape(Capsule())
            .opacity(configuration.isPressed ? 0.7 : 1.0)
        }
    }
}

#Preview(traits: .design(.baseTypography)) {
    @Previewable @Environment(\.design) var design
    VStack {
        Pill.Button("Title",
                    style: .init(foregroundColor: design.color.primary,
                                 backgroundColor: design.color.secondary,
                                 showArrow: true))
//        PillButton().disabled(true)
    }
}

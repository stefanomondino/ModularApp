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
    @MainActor var pillButton: PillButton.Provider {
        resolve(default: .init())
    }
}

public extension PillButton {
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

public struct PillButton: View {
    @Environment(\.design) var design
    let action: @Sendable () async -> Void
    let title: String
    let style: (Design) -> Style
    public init(_ title: String,
                style: Style,
                action: @Sendable @escaping @MainActor () async -> Void = {}) {
        self.action = action
        self.title = title
        self.style = { _ in style }
    }

    public init(_ title: String,
                style key: Key,
                action: @Sendable @escaping @MainActor () async -> Void = {}) {
        self.action = action
        self.title = title
        style = { $0.pillButton.get(key) }
    }

    public var body: some View {
        Button(action: { Task {
                   await action()
               } },
               label: {
                   Text("Button")
               })
               .buttonStyle(style(design))
    }
}

public extension PillButton {
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
        PillButton("Title",
                   style: .init(foregroundColor: design.color.primary,
                                backgroundColor: design.color.secondary,
                                showArrow: true))
//        PillButton().disabled(true)
    }
}

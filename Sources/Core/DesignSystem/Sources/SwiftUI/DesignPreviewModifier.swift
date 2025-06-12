//
//  DesignPreviewModifier.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//
import SwiftUI

public typealias DesignPreview = PreviewTrait<Preview.ViewTraits>

public extension PreviewTrait where T == Preview.ViewTraits {
    static func design() -> Self {
        design(.default)
    }

    static func design(_ customizations: DesignPreviewModifier.Customization...) -> Self {
        design(customizations)
    }

    static func design(_ customizations: [DesignPreviewModifier.Customization]) -> Self {
        if #available(iOS 18.0, *) {
            .modifier(DesignPreviewModifier(customizations: customizations))
        } else {
            .sizeThatFitsLayout
        }
    }
}

public struct DesignPreviewModifier: PreviewModifier {
    public struct Customization: Sendable {
        let customization: @MainActor (DesignSystem.Design) -> Void
        public init(customization: @MainActor @escaping (DesignSystem.Design) -> Void) {
            self.customization = customization
        }

        @MainActor func callAsFunction(_ design: DesignSystem.Design) -> Design {
            customization(design)
            return design
        }

        public static var `default`: Self {
            Customization { _ in }
        }
    }

    fileprivate let customizations: [Customization]
    public static func makeSharedContext() async throws -> DesignSystem.Design {
        DesignSystem.Design()
    }

    @MainActor private func customize(_ design: DesignSystem.Design) -> DesignSystem.Design {
        customizations.reduce(design) { $1($0) }
    }

    public func body(content: Content, context: Design) -> some View {
        content.environment(\.design, customize(context))
    }
}

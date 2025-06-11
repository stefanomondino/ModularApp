//
//  DesignPreviewModifier.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//
import SwiftUI

public extension PreviewTrait where T == Preview.ViewTraits {
    static var design: Self {
        if #available(iOS 18.0, *) {
            .modifier(DesignPreviewModifier())
        } else {
            .sizeThatFitsLayout
        }
    }
}

public struct DesignPreviewModifier: PreviewModifier {
    public static func makeSharedContext() async throws -> DesignSystem.Design {
        let design = DesignSystem.Design()

        design.typography.register(for: .h1) {
            Typography(family: .code, size: 25)
        }

        design.color.register(for: .primary) { "#00FF00" }
        design.color.register(for: .secondary) {
            ["#ff0000"]
        }
        return design
    }

    public func body(content: Content, context: Design) -> some View {
        content.environment(\.design, context)
    }
}

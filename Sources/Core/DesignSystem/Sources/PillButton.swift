//
//  PillButton.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import SwiftUI

public struct PillButton: View {
    public var body: some View {
        Button(action: {},
               label: {
                   Text("Button")
               })
               .buttonStyle(Style(showArrow: true))
    }
}

public extension PillButton {
    struct Style {
        public let showArrow: Bool
    }
}

extension PillButton.Style: ButtonStyle {
    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            if showArrow {
                Image(systemName: "chevron.right")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(Color.blue)
        .foregroundColor(.white)
        .clipShape(Capsule())
    }
}

#Preview {
    PillButton()
}

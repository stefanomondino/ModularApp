//
//  ContainerSizeModifier.swift
//  Components
//
//  Created by Stefano Mondino on 30/10/25.
//

import Foundation
import SwiftUI

struct ContainerSizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content.environment(\.frameSize, geometry.size)
        }
    }
}

public extension View {
    func withContainerSize() -> some View {
        modifier(ContainerSizeModifier())
    }
}

public extension EnvironmentValues {
    @Entry var frameSize: CGSize = .zero
}

#Preview {
    struct DemoView: View {
        @Environment(\.frameSize) var frameSize
        var body: some View {
            ZStack {
                Color.yellow.opacity(0.3).ignoresSafeArea()
                Text("Width: \(frameSize.width), Height: \(frameSize.height)")
            }
        }
    }
    return ZStack {
        DemoView().withContainerSize()
    }.frame(width: 300, height: 300, alignment: .top)
}

//
//  OnFirstAppearModifier.swift
//  Components_iOS
//
//  Created by Stefano Mondino on 27/07/23.
//

import Foundation
import SwiftUI

public struct OnFirstAppearModifier: ViewModifier {
    @State private var hasAppeared = false
    let onFirstAppear: () async -> Void
    public init(_ onFirstAppear: @escaping () async -> Void) {
        self.onFirstAppear = onFirstAppear
    }

    public func body(content: Content) -> some View {
        content.onAppear {
            if !hasAppeared {
                Task { @MainActor in
                    await onFirstAppear()
                    hasAppeared = true
                }
            }
        }
    }
}

public extension View {
    @inlinable func onFirstAppear(_ closure: @escaping () async -> Void) -> some View {
        modifier(OnFirstAppearModifier(closure))
    }
}

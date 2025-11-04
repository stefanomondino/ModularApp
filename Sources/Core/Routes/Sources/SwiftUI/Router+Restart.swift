//
//  Router+Restart.swift
//  Routes
//
//  Created by Stefano Mondino on 04/11/25.
//

import Foundation
import SwiftUI

struct RestartModifier: ViewModifier {
    @Environment(\.router) private var router
    let onRestart: () async -> Void
    func body(content: Content) -> some View {
        content.task {
            guard let router else { return }
            for await definition in router.definitionStream {
                if definition is RestartRouteDefinition {
                    await onRestart()
                }
            }
        }
    }
}

public extension View {
    func onRestart(perform action: @escaping () async -> Void) -> some View {
        modifier(RestartModifier(onRestart: action))
    }
}

//
//  LifecycleModifier.iOS.swift
//  Routes
//
//  Created by Stefano Mondino on 06/11/25.
//

import DesignSystem
import SwiftUI
import UIKit

@MainActor
public protocol Lifecycle: AnyObject, Observable {
    var design: Design { get }
    var router: Router { get }
    var serviceManager: ServiceManager { get }
}

public extension View {
    func lifecycle<AppState: Lifecycle>(_ lifecycle: AppState) -> some View {
        modifier(LifecycleModifier<AppState>())
            .environment(lifecycle)
    }
}

private struct LifecycleModifier<AppState: Lifecycle>: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    @Environment(AppState.self) var appState
    var design: Design { appState.design }
    var serviceManager: ServiceManager { appState.serviceManager }
    @Environment(\.colorScheme) var colorScheme
    func body(content: Content) -> some View {
        content
            .onOpenURL { url in
                _ = serviceManager.open(url: url, options: [:])
            }
            .onChange(of: scenePhase) { _, phase in
                switch phase {
                case .background:
                    serviceManager.didEnterBackground()
                case .active:
                    serviceManager.didBecomeActive()
                case .inactive: serviceManager.willResignActive()
                @unknown default:
                    break
                }
            }
            .onChange(of: colorScheme, initial: true) {
                design.updateSystemColorScheme(colorScheme)
            }
            .restartable()
            .environment(design)
            .environment(\.colorScheme, design.colorScheme ?? colorScheme)
            .environment(\.router, appState.router)
    }
}

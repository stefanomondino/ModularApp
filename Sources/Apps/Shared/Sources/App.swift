//
//  App.swift
//  ModularApp
//
//  Created by Stefano Mondino on 03/11/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DesignSystem
import Routes
import SwiftUI

@main
struct App: SwiftUI.App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    @Environment(\.scenePhase) private var scenePhase
    var appState: AppLifecycle { appDelegate.container.state }

    var body: some Scene {
        WindowGroup {
            LifecycleView()
                .environment(\.appState, appState)
                .environment(\.design, Design.shared)
                .onChange(of: scenePhase) { _, phase in
                    switch phase {
                    case .background: appDelegate.applicationDidEnterBackground(UIApplication.shared)
                    case .active: appDelegate.applicationDidBecomeActive(UIApplication.shared)
                    case .inactive: appDelegate.applicationWillResignActive(UIApplication.shared)
                    @unknown default:
                        break
                    }
                }
        }
    }
}

@MainActor
struct AppStateKey: @MainActor EnvironmentKey {
    static let defaultValue: AppLifecycle = .empty
}

extension EnvironmentValues {
    @MainActor var appState: AppLifecycle {
        get { self[AppStateKey.self] }
        set { self[AppStateKey.self] = newValue }
    }
}

public extension DesignPreviewModifier.Customization {
    static var app: Self { .init { $0.setup() } }
}

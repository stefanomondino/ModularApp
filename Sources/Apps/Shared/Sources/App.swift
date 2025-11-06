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
import Components

@main
struct App: SwiftUI.App {
        
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    var appState: AppLifecycle { appDelegate.container.state }
    
    var body: some Scene {
        WindowGroup {
            LifecycleView()
                .environment(\.appState, appState)
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

extension App {
    // Color scheme does not work directly on App - needs to be applied on a subview
    struct LifecycleView: View {
        var design: DesignSystem.Design { appState.design } 
        @Environment(\.appState) var appState: AppLifecycle
        @Environment(\.colorScheme) var colorScheme
        var body: some View {
            LaunchScreenView()
                .ignoresSafeArea()
                .restartable()
                .environment(\.router, appState.router)
                .onChange(of: colorScheme, initial: true) {
                    design.updateSystemColorScheme(colorScheme)
                }
                .environment(appState.design)
                .environment(\.colorScheme, design.colorScheme ?? colorScheme)
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

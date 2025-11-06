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
    
    var appState: AppLifecycle { appDelegate.container.state }
    
    var body: some Scene {
        WindowGroup {
            LaunchScreenView()
                .ignoresSafeArea()
                .lifecycle(appState)
        }
    }
}

public extension DesignPreviewModifier.Customization {
    static var app: Self { .init { $0.setup() } }
}

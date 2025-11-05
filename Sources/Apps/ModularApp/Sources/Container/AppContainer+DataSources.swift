//
//  AppContainer+DataSources.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 04/11/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import DependencyContainer
import Foundation
import Locations
import Onboarding
import Camera
import Notifications

extension AppContainer {
    func setupDataSources() async {
        await register(for: LocationDataSource.self, scope: .singleton) { @MainActor in
            CLLocationDataSource(manager: .init())
        }
        
        await register(for: CameraDataSource.self, scope: .singleton) { @MainActor in
            CameraPermissions()
        }
        
        await register(for: NotificationsDataSource.self, scope: .singleton) { @MainActor in
            PushNotificationPermissions()
        }
    }
}

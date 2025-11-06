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
import Tracking
import Biometric

extension AppContainer {
    func setupDataSources() async {
        await register(for: LocationDataSource.self, scope: .singleton) { @MainActor in
            CLLocationDataSource(manager: .init())
        }
        
        await register(for: CameraDataSource.self, scope: .singleton) { @MainActor in
            AVCameraDataSource()
        }
        
        await register(for: NotificationsDataSource.self, scope: .singleton) { @MainActor in
            UNNotificationsDataSource(center: .current())
        }
        
        await register(for: TrackingDataSource.self, scope: .singleton) { @MainActor in
            ATTTrackingDataSource()
        }
        
        await register(for: BiometricDataSource.self, scope: .singleton) { @MainActor in
            BiometricIDDataSource()
        }
    }
}

//
//  AppContainer+Permissions.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 24/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import Foundation
import Locations
import Networking

extension AppContainer {
    func setupPermissions() async {
        await register(for: LocationDataSource.self, scope: .singleton) {
            await CLLocationDataSource()
        }
    }
}

//
//  Location+Permission.swift
//  Permissions
//
//  Created by Stefano Mondino on 03/11/25.
//

import DataStructures
import Foundation

public extension Permission {
    static func locationWhenInUse(_ dataSource: LocationDataSource) -> Self {
        .init(.locationWhenInUse) {
            await dataSource.shouldAskForPermissions()
        } ask: {
            await dataSource.askForPermissions(mode: .whenInUse).alreadyGranted(for: .authorizedWhenInUse)
        }
    }

    static func locationAlways(_ dataSource: LocationDataSource) -> Self {
        .init(.locationAlways) {
            await dataSource.shouldAskForPermissions()
        } ask: {
            await dataSource.askForPermissions(mode: .always).alreadyGranted(for: .authorizedAlways)
        }
    }
}

public extension Permission.Identifier {
    static var locationWhenInUse: Self { "locationWhenInUse" }
    static var locationAlways: Self { "locationAlways" }
}

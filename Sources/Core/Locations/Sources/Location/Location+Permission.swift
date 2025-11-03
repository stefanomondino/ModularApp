//
//  Location+Permission.swift
//  Permissions
//
//  Created by Stefano Mondino on 03/11/25.
//

import Foundation

public extension Permission {
    static func locationWhenInUse(_ dataSource: LocationDataSource) -> Self {
        .init {
            await dataSource.shouldAskForPermissions()
        } ask: {
            await dataSource.askForPermissions(mode: .whenInUse).alreadyGranted(for: .authorizedWhenInUse)
        }
    }
}

//
//  LocationPermissionRequestMode.swift
//  Permissions
//
//  Created by Stefano Mondino on 03/11/25.
//

import CoreLocation
import Foundation

public enum LocationPermissionRequestMode: Sendable {
    case whenInUse
    case always
    var status: LocationPermissionStatus {
        switch self {
        case .whenInUse: .authorizedWhenInUse
        case .always: .authorizedAlways
        }
    }
}

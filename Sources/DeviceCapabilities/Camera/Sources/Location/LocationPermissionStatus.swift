//
//  LocationPermissionStatus.swift
//  Permissions
//
//  Created by Stefano Mondino on 03/11/25.
//

import CoreLocation
import Foundation

public enum LocationPermissionStatus: Sendable, Equatable {
    case notDetermined
    case restricted
    case denied
    case authorizedAlways
    case authorizedWhenInUse
    case unknown

    init(_ status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self = .notDetermined
        case .restricted:
            self = .restricted
        case .denied:
            self = .denied
        case .authorizedAlways:
            self = .authorizedAlways
        case .authorizedWhenInUse:
            self = .authorizedWhenInUse
        @unknown default:
            self = .unknown
        }
    }

    func alreadyGranted(for other: LocationPermissionStatus) -> Bool {
        let equivalents: Set<LocationPermissionStatus> = switch self {
        case .authorizedWhenInUse: .init([.authorizedWhenInUse, .authorizedAlways])
        default: .init([self])
        }
        return equivalents.contains(other)
    }
}

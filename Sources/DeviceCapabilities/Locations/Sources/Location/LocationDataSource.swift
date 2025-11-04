//
//  LocationDataSource.swift
//  Permissions
//
//  Created by Stefano Mondino on 03/11/25.
//

import CoreLocation
import DataStructures
import Foundation
import Streams

// sourcery: AutoMockable
@MainActor public protocol LocationDataSource: Sendable {
    func shouldAskForPermissions() async -> Bool
    func askForPermissions(mode: LocationPermissionRequestMode) async -> LocationPermissionStatus
}

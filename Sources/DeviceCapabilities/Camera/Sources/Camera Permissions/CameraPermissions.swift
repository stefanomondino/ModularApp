//
//  CameraPermissions.swift
//  Camera
//
//  Created by Renoy Chowdhury on 04/11/25.
//

import Foundation
import AVFoundation
import DataStructures

public final class CameraPermissions: CameraDataSource {
    var currentState: AVAuthorizationStatus { AVCaptureDevice.authorizationStatus(for: .video) }
    
    public init() {}
    
    public func shouldAskPermission() async -> Bool {
        currentState == .notDetermined
    }
    
    public func askForPremission() async -> Bool {
        await authorizationCheck()
        return true
    }
    
    public func authorizationCheck() async {
        switch currentState {
        case .notDetermined:
            await AVCaptureDevice.requestAccess(for: .video)
        case .authorized, .denied, .restricted: break
        @unknown default: break
        }
    }
}

public protocol CameraDataSource: Sendable {
    func shouldAskPermission() async -> Bool
    func askForPremission() async -> Bool
}

public extension Permission {
    static func cameraPermissions(_ dataSource: CameraDataSource) -> Self {
        Permission { await dataSource.shouldAskPermission() } ask: { await dataSource.askForPremission() }
    }
}

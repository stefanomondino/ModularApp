//
// Tracking.swift
//

import AppTrackingTransparency
import DataStructures
import Foundation

public final class ATTTrackingDataSource: TrackingDataSource {
    public init() {}

    public func shouldAskPermission() async -> Bool {
        await currentStatus() == .notDetermined
    }

    public func askForPremission() async -> Bool {
        await authorizationCheck()
        return true
    }

    public func authorizationCheck() async {
        let status = await currentStatus()

        switch status {
        case .notDetermined:
            await requestTrackingAuthorization()
        case .authorized, .denied, .restricted:
            break
        @unknown default:
            break
        }
    }

    private func requestTrackingAuthorization() async {
        await withCheckedContinuation { continuation in
            ATTrackingManager.requestTrackingAuthorization { _ in
                continuation.resume()
            }
        }
    }

    private func currentStatus() async -> ATTrackingManager.AuthorizationStatus {
        ATTrackingManager.trackingAuthorizationStatus
    }
}

public protocol TrackingDataSource: Sendable {
    func shouldAskPermission() async -> Bool
    func askForPremission() async -> Bool
}

public extension Permission {
    static func tracking(_ dataSource: TrackingDataSource) -> Self {
        Permission(.tracking) { await dataSource.shouldAskPermission() } ask: { await dataSource.askForPremission() }
    }
}

public extension Permission.Identifier {
    static var tracking: Self { "tracking" }
}

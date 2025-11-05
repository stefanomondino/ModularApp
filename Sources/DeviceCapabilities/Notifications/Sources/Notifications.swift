//
// Notifications.swift
//

import Foundation
import DataStructures
import UserNotifications

public final class PushNotificationPermissions: NotificationsDataSource {
    private var center: UNUserNotificationCenter { UNUserNotificationCenter.current() }

    public init() {}
    
    public func shouldAskPermission() async -> Bool {
        return await currentStatus() == .notDetermined
    }
    
    public func askForPremission() async -> Bool {
        await authorizationCheck()
        return true
    }
    
    public func authorizationCheck() async {
        switch await currentStatus() {
        case .notDetermined:
            _ = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
        case .authorized, .denied, .provisional, .ephemeral: break
        @unknown default: break
        }
    }
    
    private func currentStatus() async -> UNAuthorizationStatus {
        return await center.notificationSettings().authorizationStatus
    }
}

public protocol NotificationsDataSource: Sendable {
    func shouldAskPermission() async -> Bool
    func askForPremission() async -> Bool
}

public extension Permission {
    static func pushNotificationPermissions(_ dataSource: NotificationsDataSource) -> Self {
        Permission(.pushNotifications) { await dataSource.shouldAskPermission() } ask: { await dataSource.askForPremission() }
    }
}
public extension Permission.Identifier {
    static var pushNotifications: Self { "pushNotifications" }
}

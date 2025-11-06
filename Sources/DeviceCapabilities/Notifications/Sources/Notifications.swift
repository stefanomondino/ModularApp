//
// Notifications.swift
//

import DataStructures
import Foundation
import UserNotifications

@MainActor
public final class UNNotificationsDataSource: NotificationsDataSource {
    private let center: UNUserNotificationCenter

    public init(center: UNUserNotificationCenter) {
        self.center = center
    }

    public func shouldAskPermission() async -> Bool {
        await currentStatus() == .notDetermined
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
        await center.notificationSettings().authorizationStatus
    }
}

public protocol NotificationsDataSource: Sendable {
    func shouldAskPermission() async -> Bool
    func askForPremission() async -> Bool
}

public extension Permission {
    static func pushNotifications(_ dataSource: NotificationsDataSource) -> Self {
        Permission(.pushNotifications) { await dataSource.shouldAskPermission() } ask: { await dataSource.askForPremission() }
    }
}

public extension Permission.Identifier {
    static var pushNotifications: Self { "pushNotifications" }
}

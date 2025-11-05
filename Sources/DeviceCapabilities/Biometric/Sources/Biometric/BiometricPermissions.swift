//
//  BiometricPermissions.swift
//  Biometric
//
//  Created by Renoy Chowdhury on 05/11/25.
//

import Foundation
import LocalAuthentication
import DataStructures

public final class BiometricPermissions: BiometricDataSource {
    public init() {}

    public func shouldAskPermission() async -> Bool {
        await canUseFaceID()
    }

    public func askForPremission() async -> Bool {
        await authorizationCheck()
        return true
    }

    public func authorizationCheck() async {
        guard await canUseFaceID() else { return }
        _ = try? await evaluateFaceID(reason: "Unlock with FaceID")
    }

    private func canUseFaceID() async -> Bool {
        let context = LAContext()
        var error: NSError?
        let canEvaluate = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        return canEvaluate && context.biometryType == .faceID
    }

    private func evaluateFaceID(reason: String) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            let context = LAContext()
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, error in
                if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(returning: success)
                }
            }
        }
    }
}

public protocol BiometricDataSource: Sendable {
    func shouldAskPermission() async -> Bool
    func askForPremission() async -> Bool
}

public extension Permission {
    static func biometricPermissions(_ dataSource: BiometricDataSource) -> Self {
        Permission { await dataSource.shouldAskPermission() } ask: { await dataSource.askForPremission() }
    }
}

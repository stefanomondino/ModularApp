//
//  BiometricIDDataSource.swift
//  Biometric
//
//  Created by Renoy Chowdhury on 05/11/25.
//

import DataStructures
import Foundation
import LocalAuthentication

public final class BiometricIDDataSource: BiometricDataSource {
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
                if let error {
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
    static func biometricId(_ dataSource: BiometricDataSource) -> Self {
        Permission(.biometric) { await dataSource.shouldAskPermission() } ask: { await dataSource.askForPremission() }
    }
}

public extension Permission.Identifier {
    static var biometric: Self { "biometric" }
}

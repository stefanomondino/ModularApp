//
// Permission.swift
//

import Foundation

public struct Permission: Sendable {
    public let shouldAsk: @Sendable () async -> Bool
    public let ask: @Sendable () async throws -> Bool
    public init(shouldAsk: @Sendable @escaping () async -> Bool,
                ask: @Sendable @escaping () async throws -> Bool) {
        self.shouldAsk = shouldAsk
        self.ask = ask
    }
}

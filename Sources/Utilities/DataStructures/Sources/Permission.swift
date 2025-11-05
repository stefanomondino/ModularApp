//
// Permission.swift
//

import Foundation

public struct Permission: Sendable {
    
    public typealias Identifier = ExtensibleIdentifier<String, Self>
    public let identifier: Identifier
    public let shouldAsk: @Sendable () async -> Bool
    public let ask: @Sendable () async throws -> Bool
    public init(_ identifier: Identifier,
                shouldAsk: @Sendable @escaping () async -> Bool,
                ask: @Sendable @escaping () async throws -> Bool) {
        self.shouldAsk = shouldAsk
        self.ask = ask
        self.identifier = identifier
    }
}

//
//  Vocabulary.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 07/11/25.
//
import DataStructures
import DependencyContainer
import Foundation

@MainActor @Observable
public final class Vocabulary: MainActorProvider {
    public struct Key: ExtensibleIdentifierType, Sendable, ExpressibleByStringLiteral {
        public let value: String
        public init(_ value: String) {
            self.value = value
        }
    }

    public var storage: Storage<Key> = .init()

    public init() {}

    func get(_ key: Key) -> Translation {
        resolve(key, type: Translation.self, default: Translation(key.value))
    }

    public func register(_ dictionary: [Key: Translation]) {
        for (key, value) in dictionary {
            register(for: key) { value }
        }
    }

    public func translation(_ key: Key) -> Translation {
        get(key)
    }
}

public extension Vocabulary.Key {
    static var hello: Self { "hello" }
}

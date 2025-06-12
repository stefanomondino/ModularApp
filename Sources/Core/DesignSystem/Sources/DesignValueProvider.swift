//
//  DesignValueProvider.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 12/06/25.
//
import DataStructures
import DependencyContainer

@dynamicMemberLookup
@MainActor
public protocol DesignValueProvider: MainActorProvider where Key: ExtensibleIdentifierType & ExpressibleByStringLiteral {
    associatedtype Value: Sendable
    var defaultValue: Value { get }
    subscript(dynamicMember _: Key) -> Value { get set }
}

public extension DesignValueProvider {
    subscript(dynamicMember key: Key) -> Value {
        get {
            resolve(key, type: Value.self, default: defaultValue)
        }
        set {
            register(for: key, callback: { newValue })
        }
    }

    func get(_ key: Key) -> Value {
        resolve(key, type: Value.self, default: defaultValue)
    }
}

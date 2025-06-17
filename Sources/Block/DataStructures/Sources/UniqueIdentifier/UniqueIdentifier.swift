//
//  UniqueIdentifier.swift
//  DataStructures
//
//  Created by Stefano Mondino on 17/06/25.
//
import Foundation

/// A unique identier object.
public protocol UniqueIdentifier: Sendable {
    var stringValue: String { get }
}

extension String: UniqueIdentifier {
    public var stringValue: String { self }
}

extension UUID: UniqueIdentifier {
    public var stringValue: String { uuidString }
}

extension Int: UniqueIdentifier {
    public var stringValue: String { "\(self)" }
}

public protocol UniquelyIdentifiable {
    var uniqueIdentifier: any UniqueIdentifier { get }
}

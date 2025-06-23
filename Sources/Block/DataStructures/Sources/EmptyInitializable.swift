//
//  EmptyInitializable.swift
//  DataStructures
//
//  Created by Stefano Mondino on 23/06/25.
//

import Foundation

public protocol EmptyInitializable: Sendable {
    static var empty: Self { get }
}

extension String: EmptyInitializable {
    public static var empty: String { "" }
}

extension Bool: EmptyInitializable {
    public static var empty: Bool { false }
}

extension Int: EmptyInitializable {
    public static var empty: Int { 0 }
}

extension Double: EmptyInitializable {
    public static var empty: Double { 0.0 }
}

extension Float: EmptyInitializable {
    public static var empty: Float { 0.0 }
}

extension Array: EmptyInitializable {
    public static var empty: [Element] { [] }
}

extension Dictionary: EmptyInitializable {
    public static var empty: Self { [:] }
}

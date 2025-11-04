//
//  WithWrappedValue.swift
//  DataStructures
//
//  Created by Stefano Mondino on 23/06/25.
//

import Foundation

public protocol WithWrappedValue: Sendable, Decodable {
    associatedtype Value: Sendable & Decodable
    var wrappedValue: Value { get }
    init(_ value: Value?)
}

public extension WithWrappedValue where Value: ExpressibleByStringLiteral {
    init(stringLiteral value: Value.StringLiteralType) {
        self.init(Value(stringLiteral: value))
    }
}

public extension WithWrappedValue where Value: ExpressibleByUnicodeScalarLiteral {
    init(unicodeScalarLiteral value: Value.UnicodeScalarLiteralType) {
        self.init(Value(unicodeScalarLiteral: value))
    }
}

public extension WithWrappedValue where Value: ExpressibleByExtendedGraphemeClusterLiteral {
    init(extendedGraphemeClusterLiteral value: Value.ExtendedGraphemeClusterLiteralType) {
        self.init(Value(extendedGraphemeClusterLiteral: value))
    }
}

public extension WithWrappedValue where Value: ExpressibleByStringInterpolation {
    typealias StringInterpolation = Value.StringInterpolation
    init(stringInterpolation value: StringInterpolation) {
        self.init(.init(stringInterpolation: value))
    }
}

public extension WithWrappedValue where Value: ExpressibleByFloatLiteral {
    init(floatLiteral value: Value.FloatLiteralType) {
        self.init(Value(floatLiteral: value))
    }
}

public extension WithWrappedValue where Value: ExpressibleByBooleanLiteral {
    init(booleanLiteral value: Value.BooleanLiteralType) {
        self.init(Value(booleanLiteral: value))
    }
}

public extension WithWrappedValue where Value: ExpressibleByIntegerLiteral {
    init(integerLiteral value: Value.IntegerLiteralType) {
        self.init(Value(integerLiteral: value))
    }
}

//
//  ValuesProvider.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import DataStructures
import DependencyContainer
import Foundation
import SwiftUI

public struct NumberValue: Sendable, Hashable, ExpressibleByFloatLiteral, ExpressibleByIntegerLiteral {
    private enum UnderlyingValue: Sendable, Hashable {
        case int(Int)
        case float(Float)
        case double(Double)
    }

    init?(exactly value: some Numeric) {
        switch value {
        case let intValue as Int: self.value = .int(intValue)
        case let floatValue as Float: self.value = .float(floatValue)
        case let doubleValue as Double: self.value = .double(doubleValue)
        default: return nil
        }
    }

    private let value: UnderlyingValue
    public static let zero = NumberValue(.int(0))

    private init(_ value: UnderlyingValue) {
        self.value = value
    }

    public init(floatLiteral value: Float) {
        self.value = .float(value)
    }

    public init(integerLiteral value: Int) {
        self.value = .int(value)
    }

    public init(doubleValue value: Double) {
        self.value = .double(value)
    }

    public var floatValue: Float {
        switch value {
        case let .int(intValue): Float(intValue)
        case let .float(floatValue): floatValue
        case let .double(doubleValue): Float(doubleValue)
        }
    }

    public var doubleValue: Double {
        switch value {
        case let .int(intValue): Double(intValue)
        case let .float(floatValue): Double(floatValue)
        case let .double(doubleValue): doubleValue
        }
    }

    public var intValue: Int {
        switch value {
        case let .int(intValue): intValue
        case let .float(floatValue): Int(floatValue)
        case let .double(doubleValue): Int(doubleValue)
        }
    }
}

public extension NumberValue {
    struct Key: ExtensibleIdentifierType, ExpressibleByStringInterpolation {
        public let value: String
        public init(_ value: String) {
            self.value = value
        }
    }

    @Observable
    final class Provider: DesignValueProvider {
        public var storage: Storage<NumberValue.Key> = .init()
        public let defaultValue: NumberValue
        public init(defaultValue: NumberValue = .zero) {
            self.defaultValue = defaultValue
        }
    }
}

public extension NumberValue.Key {
    static func sidePadding(_ multiplier: CGFloat = 1) -> Self { "sidePadding\(multiplier)" }
    static func cornerRadius(_ multiplier: CGFloat = 1) -> Self { "cornerRadius\(multiplier)" }
}

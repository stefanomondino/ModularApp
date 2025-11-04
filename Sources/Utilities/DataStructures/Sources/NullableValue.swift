//
//  NullableValue.swift
//  DataStructures
//
//  Created by Stefano Mondino on 23/06/25.
//
import Foundation

@propertyWrapper
public struct NullableValue<Value: EmptyInitializable & Decodable>: EmptyInitializable, WithWrappedValue {
    fileprivate var innerValue: Value?
    private let emptyValue: Value = .empty
    public var wrappedValue: Value {
        get {
            innerValue ?? emptyValue
        }
        set {
            innerValue = newValue
        }
    }

    public static var empty: Self {
        .init()
    }

    public init(_ value: Value? = nil) {
        innerValue = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        do {
            innerValue = try container.decode(Value.self)
        } catch {
            switch error {
            case DecodingError.valueNotFound:
                innerValue = nil
            default: throw error
            }
        }
    }
}

extension NullableValue: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let innerValue {
            try container.encode(innerValue)
        }
    }
}

public extension KeyedDecodingContainer {
    func decode<Value>(_ type: NullableValue<Value>.Type, forKey key: K) throws -> NullableValue<Value> where Value: Sendable & Decodable {
        if let value = try decodeIfPresent(type, forKey: key) {
            return value
        }
        return NullableValue()
    }
}

public extension KeyedEncodingContainer {
    mutating func encode<Value>(_ value: NullableValue<Value>, forKey key: K) throws where Value: Sendable & Encodable {
        if let innerValue = value.innerValue {
            try encodeIfPresent(innerValue, forKey: key)
        }
    }
}

extension NullableValue: ExpressibleByNilLiteral {
    public init(nilLiteral _: ()) {
        self.init(nil)
    }
}

extension NullableValue: ExpressibleByBooleanLiteral where Value: ExpressibleByBooleanLiteral {}
extension NullableValue: ExpressibleByIntegerLiteral where Value: ExpressibleByIntegerLiteral {}
extension NullableValue: ExpressibleByFloatLiteral where Value: ExpressibleByFloatLiteral {}
extension NullableValue: ExpressibleByStringLiteral where Value: ExpressibleByStringLiteral {}
extension NullableValue: ExpressibleByUnicodeScalarLiteral where Value: ExpressibleByUnicodeScalarLiteral {}
extension NullableValue: ExpressibleByExtendedGraphemeClusterLiteral where Value: ExpressibleByExtendedGraphemeClusterLiteral {}
extension NullableValue: ExpressibleByStringInterpolation where Value: ExpressibleByStringInterpolation {}

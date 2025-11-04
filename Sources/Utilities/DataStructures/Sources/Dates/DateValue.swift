//
//  DateValue.swift
//  DataStructures
//
//  Created by Stefano Mondino on 27/07/25.
//

import Foundation

/// Property wrapper for encoding and decoding a `Date` value using a customizable raw representation and format.
///
/// `DateValue` allows you to work with `Date`-like values, decoding and encoding them using a provided `DateFormat` type with a raw type (like `String` or `Int`).
/// Use it to flexibly parse, encode, and store dates from non-standard formats in Codable types.
///
/// - Parameters:
///   - Format: The format type for parsing and formatting dates, conforming to `DateFormat`.
///   - Value: The wrapped value type, typically `Date` or `Date?`, conforming to `ExpressibleByDate`.
///
/// The wrapped value is accessible via `.wrappedValue` or `.date`.
@propertyWrapper
public struct DateValue<Format: DateFormat, Value: ExpressibleByDate>: Codable, Sendable {
    /// The stored `Date` value.
    public private(set) var date: Value

    /// The wrapped `Date` value accessed via the property wrapper.
    public var wrappedValue: Value {
        get { date }
        set { date = newValue }
    }

    /// Creates a `DateValue` from a time interval since 1970.
    /// - Parameter interval: Time interval since 1970.
    public init(_ interval: TimeInterval) {
        date = .init(Date(timeIntervalSince1970: interval))
    }

    /// Creates a `DateValue` from a `Date`.
    /// - Parameter date: The `Date` value.
    public init(_ date: Value) {
        self.date = date
    }

    /// Attempts to create a `DateValue` from a raw representation using the specified `Format`.
    /// Returns `nil` if the raw value cannot be parsed into a `Date`.
    /// - Parameter raw: The raw encoded value.
    public init?(_ raw: Format.RawType) {
        guard let date = Format.format(raw) else {
            return nil
        }
        self.date = .init(date)
    }

    /// Decodes the `DateValue` from the given decoder.
    /// Throws if the raw value cannot be decoded or parsed into a valid `Date`.
    /// - Parameter decoder: The decoder to read data from.
    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(Format.RawType.self)
        if let value = DateValue(raw) {
            self = value
        } else {
            throw DecodingError.dataCorruptedError(in: container,
                                                   debugDescription: "Invalid date string format.")
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        if let date = date.date {
            try container.encode(Format.format(date))
        } else {
            try container.encodeNil()
        }
    }
}

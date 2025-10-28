//
//  ExpressibleByDate.swift
//  DataStructures
//
//  Created by Stefano Mondino on 04/08/25.
//
import Foundation

/// A type that can be initialized with a Date and can provide a Date value.
public protocol ExpressibleByDate: Sendable {
    /// Initializes an instance with the given Date value.
    init(_ date: Date)
    /// Returns the underlying Date value if available.
    var date: Date? { get }
}

/// Conformance for Date to ExpressibleByDate, allowing direct initialization and value extraction.
extension Date: ExpressibleByDate {
    /// Initializes a Date with the provided Date value (identity initializer).
    public init(_ date: Date) {
        self = date
    }

    /// Returns self as the Date value.
    public var date: Date? { self }
}

/// Conformance for Optional<Date> to ExpressibleByDate, allowing direct initialization and value extraction.
extension Optional: ExpressibleByDate where Wrapped == Date {
    /// Initializes an Optional<Date> with the provided Date value.
    public init(_ date: Date) {
        self = date
    }

    /// Returns self as the Date value, or nil if none.
    public var date: Date? { self }
}

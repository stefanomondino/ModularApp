//
//  TimeIntervalFormat.swift
//  DataStructures
//
//  Created by Stefano Mondino on 04/08/25.
//

import Foundation

/// A `DateFormat` implementation for time intervals (seconds since reference date).
///
/// Parses and formats dates using their time interval representation (Double).
///
/// Example: "727484445.0"
public struct TimeIntervalFormat: DateFormat {
    /// Parses a string as a time interval (Double) and returns the corresponding `Date`.
    public static func format(_ raw: Double) -> Date? {
        Date(timeIntervalSince1970: raw)
    }

    /// Formats a `Date` as a time interval (Double) string.
    public static func format(_ date: Date) -> Double? {
        date.timeIntervalSince1970
    }
}

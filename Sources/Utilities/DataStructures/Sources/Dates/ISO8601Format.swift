//
//  ISO8601Format.swift
//  DataStructures
//
//  Created by Stefano Mondino on 04/08/25.
//

import Foundation

/// A `DateFormat` implementation for ISO8601 date strings with second precision.
///
/// Parses and formats dates using the pattern: "yyyy-MM-dd'T'HH:mm:ssZ".
///
/// Example: "2025-07-27T15:30:45+0000"
public struct ISO8601Format: DateFormat {
    public static func format(_ raw: String) -> Date? {
        format(raw, format: dateFormat)
    }

    public static func format(_ date: Date) -> String? {
        format(date, format: dateFormat)
    }

    public static var dateFormat: String { "yyyy-MM-dd'T'HH:mm:ssZ" }
}

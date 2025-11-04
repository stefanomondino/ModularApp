//
//  ISO8601SafeFormat.swift
//  DataStructures
//
//  Created by Stefano Mondino on 04/08/25.
//

import Foundation

/// A `DateFormat` for ISO8601 date strings with optional fractional seconds (up to microsecond precision).
///
/// Parses strings like:
///   - "2025-07-27T15:30:45Z"
///   - "2025-07-27T15:30:45.123456Z"
/// and other variants with 1–6 fraction digits.
public struct ISO8601SafeFormat: DateFormat {
    public static func format(_ raw: String) -> Date? {
        let baseFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let base = format(raw, format: baseFormat + "Z") {
            return base
        } else {
            for customFormat in (1 ... 6).reversed().map({ "\(baseFormat).\(String(repeating: "S", count: $0))Z" }) {
                if let value = format(raw, format: customFormat) {
                    return value
                }
            }
        }
        return nil
    }

    public static func format(_ date: Date) -> String? {
        let baseFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        return format(date, format: baseFormat)
    }
}

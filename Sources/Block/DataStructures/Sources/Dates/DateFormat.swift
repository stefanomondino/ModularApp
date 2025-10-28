//
//  DateFormat.swift
//  DataStructures
//
//  Created by Stefano Mondino on 04/08/25.
//
import Foundation

/// Describes the requirements for converting between a raw representation and a `Date` instance.
///
/// Conform to `DateFormat` to provide static methods that parse from and format to a raw type (such as `String` or `Int`).
/// Used with property wrappers like `DateValue` for custom date decoding and encoding.
///
/// - AssociatedType: RawType — the type used for encoded/decoded date values.
/// - Methods: `format(_:)` for decoding; `format(_:)` for encoding.
public protocol DateFormat {
    associatedtype RawType: Codable
    static func format(_ raw: RawType) -> Date?
    static func format(_ date: Date) -> RawType?
}

public extension DateFormat where RawType == String {
    /// Parses a date string into a `Date` object using the specified date format string.
    ///
    /// This static helper method is intended for use by types conforming to `DateFormat` where the raw type is `String`.
    /// It utilizes a `DateFormatter` configured with the provided format string, a fixed `en_US_POSIX` locale, and the UTC time zone,
    /// ensuring consistent and locale-independent parsing results. This is particularly useful for handling dates in standardized
    /// formats (such as ISO8601 or custom patterns) when decoding from strings.
    ///
    /// - Parameters:
    ///   - raw: The raw string representing the date to be parsed.
    ///   - format: The format string to use for parsing the date (e.g., `"yyyy-MM-dd'T'HH:mm:ssZ"`).
    /// - Returns: A `Date` object if parsing is successful; otherwise, `nil`.
    ///
    /// - Note: For performance-sensitive scenarios, consider reusing a configured `DateFormatter` instance
    ///   rather than creating one on each call, as done here for simplicity.
    ///
    /// - SeeAlso: `DateValue`, `StringDateValue`, `DateFormat`
    static func format(_ raw: RawType, format: String) -> Date? {
        let formatter = DateFormatter()
        // https://forums.swift.org/t/dateformatter-rounds-a-time-to-milliseconds/55024/4
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format
        return formatter.date(from: raw)
    }

    static func format(_ date: Date, format: String) -> String {
        let formatter = DateFormatter()
        // https://forums.swift.org/t/dateformatter-rounds-a-time-to-milliseconds/55024/4
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

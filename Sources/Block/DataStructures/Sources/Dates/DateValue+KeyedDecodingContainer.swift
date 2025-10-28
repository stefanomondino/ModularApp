//
//  DateValue+KeyedDecodingContainer.swift
//  DataStructures
//
//  Created by Stefano Mondino on 04/08/25.
//

import Foundation

public extension KeyedDecodingContainer {
    /// Decodes a nullable `DateValue` for the specified key, defaulting to `.init(nil)` if no value is present.
    func decode<Format>(_ type: DateValue<Format, Date?>.Type, forKey key: K) throws -> DateValue<Format, Date?> where Format: DateFormat {
        if let value = try decodeIfPresent(type, forKey: key) {
            return value
        }
        return DateValue(nil)
    }
}

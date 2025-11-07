//
//  Translation.swift
//  Translations
//
//  Created by Stefano Mondino on 07/11/25.
//

import Foundation

public struct Translation: Sendable, ExpressibleByStringInterpolation {
    public let value: String
    public init(stringLiteral value: String) {
        self.value = value
    }

    public init(_ value: CustomStringConvertible) {
        self.value = value.description
    }

    public func format(_ parameters: [String: String] = [:]) -> String {
        parameters.reduce(value) { accumulator, pair in
            accumulator.replacingOccurrences(of: "{\(pair.key)}",
                                             with: pair.value)
        }
    }
}

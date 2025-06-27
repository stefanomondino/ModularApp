//
//  Request+QueryParameters.swift
//  Networking
//
//  Created by Stefano Mondino on 27/06/25.
//

import Foundation

public extension Request {
    struct QueryParameters: Sendable, ExpressibleByDictionaryLiteral, Hashable {
        public typealias Key = String
        public typealias Value = String
        public var parameters: [Key: Value]
        public var isEmpty: Bool {
            parameters.isEmpty
        }

        var queryItems: [URLQueryItem] {
            parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        public init(dictionaryLiteral elements: (String, Value)...) {
            parameters = Dictionary(uniqueKeysWithValues: elements.map { ($0.0, $0.1) })
        }

        init(_ parameters: [Key: Value]) {
            self.parameters = parameters
        }
    }
}

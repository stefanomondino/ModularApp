//
//  Request+Path.swift
//  Networking
//
//  Created by Stefano Mondino on 27/06/25.
//

public extension Request {
    struct Path: CustomStringConvertible, Sendable, ExpressibleByStringInterpolation, ExpressibleByArrayLiteral, Hashable {
        private var value: String
        public var description: String {
            value
        }

        public init(_ value: String) {
            self.value = "/" + value.components(separatedBy: "/")
                .filter { !$0.isEmpty }
                .joined(separator: "/")
        }

        public init(stringLiteral value: String) {
            self.init(value)
        }

        public init(arrayLiteral elements: Path...) {
            value = "/" + elements.map { $0.description }
                .filter { !$0.isEmpty }
                .joined(separator: "/")
        }
    }
}

//
//  Error.swift
//  Forms
//
//  Created by Stefano Mondino on 05/11/25.
//

import DataStructures
import Foundation

public extension Form {
    struct Error: LocalizedError {
        public struct Code: ExtensibleIdentifierType, ExpressibleByStringLiteral {
            public let value: String
            public init(_ value: String) {
                self.value = value
            }

            public static var emptyValue: Self { "emptyValue" }
        }

        public let code: Code
        public let message: String
        public init(code: Code, message: String) {
            self.code = code
            self.message = message
        }

        public var errorDescription: String? {
            message
        }
    }
}

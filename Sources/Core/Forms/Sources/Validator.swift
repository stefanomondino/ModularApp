//
//  Validator.swift
//  Forms
//
//  Created by Stefano Mondino on 05/11/25.
//

import Foundation

public struct Validator<Value: Sendable>: Sendable {
    public let validate: @MainActor @Sendable (Value) async throws -> Void
    public init(validate: @escaping @MainActor @Sendable (Value) async throws -> Void) {
        self.validate = validate
    }

    public static func none() -> Validator<Value> {
        Validator<Value> { _ in }
    }
}

public extension Validator where Value == String {
    static func nonEmpty(_ fieldName: String) -> Validator<String> {
        Validator<String> { value in
            guard !value.isEmpty else {
                throw Form.Error(code: .emptyValue,
                                 message: "Field \(fieldName) is empty")
            }
        }
    }
}

//
// Field.swift
//

import Foundation
import Streams
import SwiftUI

public enum Fields {}

@MainActor public protocol Field: Sendable {
    associatedtype Element: Sendable
    associatedtype Properties: Sendable, Identifiable
    var validator: Validator<Element> { get }
    var value: Property<Element> { get }
    var properties: Properties { get }
    func validate() async throws
}

public extension Field {
    func validate() async throws {
        try await validator.validate(value.value)
    }
}

@MainActor
public struct FieldBuilder: Identifiable {
    public let id: UUID = .init()
    public let buildView: @MainActor @Sendable () -> any SwiftUI.View
    public let validate: @Sendable () async throws -> Void
    public init<Value: Field>(field: Value, buildView: @MainActor @Sendable @escaping (Value) -> any SwiftUI.View) {
        self.buildView = { buildView(field) }
        validate = { try await field.validate() }
    }

    public init(buildView: @MainActor @Sendable @escaping () -> any SwiftUI.View) {
        self.buildView = buildView
        validate = {}
    }
}

public extension FieldBuilder {
    static func textField(value: Property<String>,
                          properties: Fields.Text.Properties,
                          validator: Validator<String> = .none()) -> FieldBuilder {
        let field = Fields.Text.ViewModel(value, properties: properties, validator: validator)
        return FieldBuilder(field: field) { field in
            Fields.Text.View(viewModel: field)
        }
    }

    static func checkbox(value: Property<Bool>,
                         properties: Fields.Checkbox.Properties) -> FieldBuilder {
        let field = Fields.Checkbox.ViewModel(value, properties: properties)
        return FieldBuilder(field: field) { field in
            Fields.Checkbox.View(viewModel: field)
        }
    }

    static func view(buildView: @MainActor @Sendable @escaping () -> any SwiftUI.View) -> FieldBuilder {
        .init(buildView: buildView)
    }
}

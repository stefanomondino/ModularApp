//
//  Form.swift
//  Forms
//
//  Created by Stefano Mondino on 05/11/25.
//

import SwiftUI
import DataStructures
import Streams

@Observable
public final class Form: Sendable {
    let fields: [FieldBuilder]
    init(_ fields: [FieldBuilder]) {
        self.fields = fields
    }
    func validate() async -> [Swift.Error] {
        var errors: [Swift.Error] = []
        for fieldBuilder in fields {
            do {
                try await fieldBuilder.validate()
            } catch {
                errors.append(error)
            }
        }
        return errors
    }
}

public extension Form {
    struct View: SwiftUI.View {
        let form: Form
        public init(_ form: Form) {
            self.form = form
        }
        public var body: some SwiftUI.View {
            VStack {
                ForEach(form.fields) { fieldBuilder in
                    AnyView(fieldBuilder.buildView())
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var text: String = ""
    @Previewable @State var form = Form([
        .textField(value: .init(""), properties: .init(title: "Test without validation")),
        .textField(value: .init(""), properties: .init(title: "Test with validation"), validator: .nonEmpty("Test with validation")),
        .checkbox(value: .init(true), properties: .init(title: "Flag")),
        .view { Text("Hello World") }
        ])
    VStack {
        Form.View(form)
        Text(text)
        Button("Validate") {
            Task {
                text = await form.validate().map { $0.localizedDescription }.joined(separator: ", ")
            }
        }
    }
}

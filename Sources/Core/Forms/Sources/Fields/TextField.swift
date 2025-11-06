//
//  TextField.swift
//  Forms
//
//  Created by Stefano Mondino on 05/11/25.
//

import Streams
import SwiftUI

public extension Fields {
    enum Text {
        public struct View<ViewModel: Field>: SwiftUI.View where ViewModel.Element == String, ViewModel.Properties == Fields.Text.Properties {
            @State var viewModel: ViewModel
            public var body: some SwiftUI.View {
                VStack(alignment: .leading) {
                    SwiftUI.Text(viewModel.properties.title)
                    SwiftUI.TextField(viewModel.properties.placeholder,
                                      text: viewModel.value.binding)
                }
            }
        }

        public struct Properties: Sendable, Identifiable {
            public let id = UUID()
            public let title: String
            public let placeholder: String
            public init(title: String, placeholder: String = "") {
                self.title = title
                self.placeholder = placeholder
            }
        }

        @Observable public final class ViewModel: Field {
            public typealias Properties = Fields.Text.Properties
            public let value: Property<String>
            public let properties: Properties
            public var validator: Validator<String>
            public init(_ value: Property<String>,
                        properties: Properties,
                        validator: Validator<String> = .none()) {
                self.value = value
                self.properties = properties
                self.validator = validator
            }
        }
    }
}

#Preview {
    Fields.Text.View(viewModel: Fields.Text.ViewModel(.init(""),
                                                      properties: .init(title: "Ciao",
                                                                        placeholder: "Inserisci testo")))
}

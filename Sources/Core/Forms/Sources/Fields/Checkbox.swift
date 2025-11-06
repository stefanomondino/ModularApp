//
//  Checkbox.swift
//  Forms
//
//  Created by Stefano Mondino on 05/11/25.
//

import Streams
import SwiftUI

public extension Fields {
    enum Checkbox {
        public struct View<ViewModel: Field>: SwiftUI.View where ViewModel.Element == Bool, ViewModel.Properties == Fields.Checkbox.Properties {
            @State var viewModel: ViewModel
            public var body: some SwiftUI.View {
                VStack(alignment: .leading) {
                    SwiftUI.Text(viewModel.properties.title)
                    SwiftUI.Toggle(isOn: viewModel.value.binding) {
                        SwiftUI.Text(viewModel.properties.placeholder)
                    }
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
            public typealias Properties = Fields.Checkbox.Properties
            public let value: Property<Bool>
            public let properties: Properties
            public var validator: Validator<Bool>
            public init(_ value: Property<Bool>,
                        properties: Properties,
                        validator: Validator<Bool> = .none()) {
                self.value = value
                self.properties = properties
                self.validator = validator
            }
        }
    }
}

#Preview {
    Fields.Checkbox.View(viewModel: Fields.Checkbox.ViewModel(.init(false),
                                                              properties: .init(title: "Ciao",
                                                                                placeholder: "Inserisci testo")))
    Fields.Checkbox.View(viewModel: Fields.Checkbox.ViewModel(.init(true),
                                                              properties: .init(title: "Ciao",
                                                                                placeholder: "Inserisci altro testo")))
}

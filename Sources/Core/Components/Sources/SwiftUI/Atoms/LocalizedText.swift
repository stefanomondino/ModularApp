//
//  LocalizedText.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 07/11/25.
//

import SwiftUI
import Translations

public struct LocalizedText: View {
    @Environment(Vocabulary.self) var vocabulary
    private let value: (Vocabulary) -> String

    public init(_ key: Vocabulary.Key,
                customization: @escaping (Translation) -> String = { $0.format() }) {
        value = { vocabulary in
            customization(vocabulary.translation(key))
        }
    }

    public init(_ translation: Translation,
                customization: @escaping (Translation) -> String = { $0.format() }) {
        value = { _ in
            customization(translation)
        }
    }

    public init(string: String) {
        value = { _ in
            string
        }
    }

    public var body: some View {
        Text(value(vocabulary))
    }
}

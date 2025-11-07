//
// TranslationsTests.swift
//

import Foundation
import Testing
@testable import Translations

@Suite
struct TranslationsTests {
    @Test("Translation should format parameters properly")
    func testTranslationFormatting() async throws {
        let translation: Translation = "Ciao {name}"
        #expect(translation.format(["name": "Stefano"]) == "Ciao Stefano")
    }
}

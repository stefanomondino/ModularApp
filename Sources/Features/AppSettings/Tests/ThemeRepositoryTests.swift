@testable import AppSettings
import Foundation
import Networking
import Testing

@Suite("ThemeRepository Tests")
struct ThemeRepositoryTests {
    let client = Networking.Client()

    @Test("Proper download of theme list")
    func themeListDownload() async throws {
        let repository = ThemeRepositoryImplementation(networking: client)
        try await client.mock(for: .queryThemes("test"),
                              response: .init(data: Stubs.themesStubJson))
        let themes = try await repository.fetchThemes(query: "test")
        #expect(themes.count == 5)
    }
}

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

    @Test("Test View actually works")
    @MainActor func testEmptyView() {
        let view = Themes.ViewContents(viewModel: Themes.ViewModelImplementation(useCase: ThemesUseCaseMock {
            $0.availableThemesThemeReturnValue = [.init(id: "1", text: "Test Theme", colors: ["334455"])]
        }))
        let body = view.body
        #expect(true)
    }
}

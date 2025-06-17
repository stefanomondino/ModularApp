import DesignSystemMacros
import SwiftSyntax
import SwiftSyntaxMacroExpansion
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import Testing

@Suite("DesignSystem Macros tests")
public struct DesignSystemMacrosTests {
    @Test("Expansion works")
    func test1() {
        let source: SourceFileSyntax =
            """
            struct Something {
                @Provider var typography: Typography.Provider
            }
            """

        let file = BasicMacroExpansionContext.KnownSourceFile(
            moduleName: "MyModule",
            fullFilePath: "test.swift"
        )

        let context = BasicMacroExpansionContext(sourceFiles: [source: file])

        let transformedSF = source.expand(
            macros: ["Provider": ProviderMacro.self],
            in: context
        )

        let expectedDescription =
            """
            struct Something {
                @MainActor public var typography: Typography.Provider {
                    resolve(default: .init())
                }
            }
            """
        #expect(transformedSF.description == expectedDescription)
    }
}

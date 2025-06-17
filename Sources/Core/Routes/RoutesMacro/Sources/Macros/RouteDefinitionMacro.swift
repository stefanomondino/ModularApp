import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct RouteDefinitionMacro {
    struct CustomError: Error, CustomStringConvertible {
        let description: String
        init(_ description: String) { self.description = description }
    }

    public init() {}
}

extension RouteDefinitionMacro: AccessorMacro {
    public static func expansion(
        of _: AttributeSyntax,
        providingAccessorsOf _: some DeclSyntaxProtocol,
        in _: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        return []
    }
}

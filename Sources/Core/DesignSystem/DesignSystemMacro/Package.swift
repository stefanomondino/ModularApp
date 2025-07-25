// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let name = "DesignSystem"

let package = Package(
    name: "\(name)Macro",
    platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6), .macCatalyst(.v13)],
    products: [ // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "\(name)Macro",
            targets: ["\(name)Macro"]
        ),
        .executable(
            name: "\(name)Client",
            targets: ["\(name)Client"]
        )
    ],
    dependencies: [ // Depend on the Swift 5.9 release of SwiftSyntax
        .package(url: "https://github.com/apple/swift-syntax.git", from: "600.0.0")
    ],
    targets: [ // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "\(name)Macros",
            dependencies: [.product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                           .product(name: "SwiftCompilerPlugin", package: "swift-syntax")],
            path: "Sources/Macros"

        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(name: "\(name)Macro",
                dependencies: [.init(stringLiteral: "\(name)Macros")],
                path: "Sources/Library"),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(name: "\(name)Client",
                          dependencies: [.init(stringLiteral: "\(name)Macro")],
                          path: "Sources/Client"),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "\(name)MacrosTests",
            dependencies: [.init(stringLiteral: "\(name)Macros"),
                           .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")]
        )
    ]
)

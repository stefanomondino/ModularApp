// The Swift Programming Language
// https://docs.swift.org/swift-book

@attached(accessor)
public macro Provider<InnerType>(_ defaultValue: InnerType) = #externalMacro(module: "DesignSystemMacros", type: "ProviderMacro")

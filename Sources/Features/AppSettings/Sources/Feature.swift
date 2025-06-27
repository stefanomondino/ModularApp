//
//  Feature.swift
//  Settings
//
//  Created by Stefano Mondino on 17/06/25.
//

import DependencyContainer
import DesignSystem
import Routes

public protocol FeatureContainer: DependencyContainer where DependencyKey == ObjectIdentifier {
    func routeContainer() async -> Router.Container
}

public final class Feature<Container: FeatureContainer>: Routes.Feature {
    let dependencies: Container
    public let container: ObjectContainer
    public var services: [any Service] {
        get async { [] }
    }

    public init(_ container: Container) async {
        dependencies = container
        self.container = await container.container
        await setupRepositories()
        await setupUseCases()
        await setupRoutes()
    }
}

extension Router.Identifier {
    struct EntryPoint: RouteDefinition, Equatable {
        var identifier: String { "AppSettingsEntryPoint" }
    }

    public static func appSettings() -> Self {
        .init(EntryPoint())
    }
}

public extension Asset.Key {
    static var themeIcon: Self { "themeIcon" }
}

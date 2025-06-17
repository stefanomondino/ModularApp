//
//  Feature.swift
//  Onboarding
//
//  Created by Stefano Mondino on 17/06/25.
//

import DependencyContainer
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
        await setupRoutes()
    }
}

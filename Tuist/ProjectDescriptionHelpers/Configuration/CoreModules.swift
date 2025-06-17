import ProjectDescription
import SkeletonPlugin

public extension Skeleton.CoreModule {
    static func designSystem() -> Self {
        .init(name: "DesignSystem",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(block: [.logger(), .dependencyContainer(), .streams(), .dataStructures()]),
              testDependencies: .init(test: [.coreTesting()]),
              synthesizers: [],
              hasMacros: true)
    }

    static func routes() -> Self {
        .init(name: "Routes",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(block: [],
                                  core: [.designSystem()]),
              testDependencies: .init(test: [.coreTesting()]),
              synthesizers: [],
              hasMacros: true)
    }
}

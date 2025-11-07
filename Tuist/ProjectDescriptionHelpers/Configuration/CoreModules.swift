import ProjectDescription
import SkeletonPlugin

public extension Skeleton.CoreModule {
    static func designSystem() -> Self {
        .init(name: "DesignSystem",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(utilities: [.logger(), .dependencyContainer(), .streams(), .dataStructures()]),
              testDependencies: .init(test: [.coreTesting()]),
              synthesizers: [],
              hasMacros: true)
    }

    static func components() -> Self {
        .init(name: "Components",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(core: [.designSystem(), .images(), .translations()]),
              testDependencies: .init(test: [.coreTesting()]),
              synthesizers: [],
              hasMacros: false)
    }

    static func routes() -> Self {
        .init(name: "Routes",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(utilities: [],
                                  core: [.designSystem(), .translations()]),
              testDependencies: .init(test: [.coreTesting()]),
              synthesizers: [],
              hasMacros: true)
    }

    static func networking() -> Self {
        .init(name: "Networking",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(utilities: [.dataStructures(), .logger(), .dependencyContainer(), .streams()],
                                  core: []),
              testDependencies: .init(test: [.coreTesting()],
                                      external: [.flyingFox()]),
              synthesizers: [],
              hasMacros: false)
    }

    static func forms() -> Self {
        .init(name: "Forms",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(utilities: [],
                                  core: [.components()]),
              testDependencies: .init(test: [.coreTesting()],
                                      external: []),
              synthesizers: [],
              hasMacros: false)
    }

    static func images() -> Self {
        .init(name: "Images",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(utilities: [.dataStructures(), .logger(), .dependencyContainer(), .streams()],
                                  core: [.designSystem()],
                                  external: [.kingfisher()]),
              testDependencies: .init(test: [.coreTesting()],
                                      external: []),
              synthesizers: [],
              hasMacros: false)
    }

    static func translations() -> Self {
        .init(name: "Translations",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(utilities: [.dataStructures(), .logger(), .dependencyContainer(), .streams()],
                                  core: []),
              testDependencies: .init(test: [.coreTesting()],
                                      external: []),
              synthesizers: [],
              hasMacros: false)
    }
    // murray: declaration
}

import ProjectDescription
import SkeletonPlugin

public extension Skeleton.DeviceCapabilityModule {
    static func locations() -> Self {
        .init(name: "Locations",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(utilities: [.dataStructures(), .logger(), .dependencyContainer(), .streams()]),
              testDependencies: .init(test: [.coreTesting()],
                                      external: []),
              synthesizers: [],
              hasMacros: false)
    }

    static func camera() -> Self {
        .init(name: "Camera",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(utilities: [.dataStructures(), .logger(), .dependencyContainer(), .streams()]),
              testDependencies: .init(test: [.coreTesting()],
                                      external: []),
              synthesizers: [],
              hasMacros: false)
    }

    static func tracking() -> Self {
        .init(name: "Tracking",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(utilities: [.dataStructures(), .logger(), .dependencyContainer(), .streams()],
                                  external: []),
              testDependencies: .init(test: [.coreTesting()],
                                      external: []),
              synthesizers: [],
              hasMacros: false)
    }

    static func notifications() -> Self {
        .init(name: "Notifications",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(utilities: [.dataStructures(), .logger(), .dependencyContainer(), .streams()],
                                  external: []),
              testDependencies: .init(test: [.coreTesting()],
                                      external: []),
              synthesizers: [],
              hasMacros: false)
    }

    static func biometric() -> Self {
        .init(name: "Biometric",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              swiftVersion: .v6,
              dependencies: .init(utilities: [.dataStructures(), .logger(), .dependencyContainer(), .streams()],
                                  external: []),
              testDependencies: .init(test: [.coreTesting()],
                                      external: []),
              synthesizers: [],
              hasMacros: false)
    }
    // murray: declaration
}

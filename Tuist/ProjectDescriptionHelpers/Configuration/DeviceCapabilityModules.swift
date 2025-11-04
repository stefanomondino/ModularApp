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
    // murray: declaration
}

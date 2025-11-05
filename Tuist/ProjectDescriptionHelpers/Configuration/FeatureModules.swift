import ProjectDescription
import SkeletonPlugin

public extension Skeleton.FeatureModule {
    static func onboarding() -> Self {
        .init(name: "Onboarding",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              dependencies: .init(core: [.routes(), .networking(), .components()],
                                  deviceCapabilities: [.locations(), .camera(), .tracking(), .notifications(), .biometric()],
                                  external: []),
              testDependencies: .init(test: [.coreTesting()]),
              synthesizers: [])
    }

    static func appSettings() -> Self {
        .init(name: "AppSettings",
              destinations: Constants.destinations,
              deploymentTargets: .custom,
              dependencies: .init(core: [.routes(), .networking(), .components()],
                                  external: [.kingfisher()]),
              testDependencies: .init(test: [.coreTesting()]),
              synthesizers: [.files(extensions: ["json"])])
    }

    static func authorization() -> Self {
  .init(name: "Authorization",
               destinations: Constants.destinations,
               deploymentTargets: .custom,
               dependencies: .init(core: [.routes(), .networking(), .forms()],
                                           deviceCapabilities: [],
                                           external: []),
              testDependencies: .init(test: [.coreTesting()]),
               synthesizers: [])
}
// murray: declaration
}

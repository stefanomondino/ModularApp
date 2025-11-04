import ProjectDescription
import SkeletonPlugin

public extension Skeleton.FeatureModule {
    static func onboarding() -> Skeleton.FeatureModule {
        Skeleton.FeatureModule(name: "Onboarding",
                               destinations: Constants.destinations,
                               deploymentTargets: .custom,
                               dependencies: .init(core: [.routes(), .networking(), .components()],
                                                   deviceCapabilities: [.locations(), .camera(), .tracking(), .notifications()],
                                                   external: []),
                               testDependencies: .init(test: [.coreTesting()]),
                               synthesizers: [])
    }

    static func appSettings() -> Skeleton.FeatureModule {
        Skeleton.FeatureModule(name: "AppSettings",
                               destinations: Constants.destinations,
                               deploymentTargets: .custom,
                               dependencies: .init(core: [.routes(), .networking(), .components()],
                                                   external: [.kingfisher()]),
                               testDependencies: .init(test: [.coreTesting()]),
                               synthesizers: [.files(extensions: ["json"])])
    }
}

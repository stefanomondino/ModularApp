import ProjectDescription
import SkeletonPlugin

public typealias Platforms = Set<Platform>

public enum Constants {
    public static let destinations: Destinations = [.iPhone]
    public static let iOSDestinations: Destinations = [.iPhone]
    public static let projectName: String = "ModularApp"
    public static let organizationName: String = "Stefano Mondino"
    public static let slackChannel: String = ""
    public static let distributionGroups = [""]
    public static let iOSDeploymentTarget: String = "17.0"
    public static let defaultTeamID = ""
    public static let defaultAppstoreConnectTeamName = "Stefano Mondino"
}

@MainActor public let coreModules: [Skeleton.CoreModule] = [.designSystem(),
                                                            .networking(),
                                                            .routes(),
                                                            // murray: core integration
                                                            .components()]

@MainActor public let deviceCapabilityModules: [Skeleton.DeviceCapabilityModule] = [.locations(), .camera()
                                                                                    // murray: device capability integration]
]

@MainActor public let utilityModules: [Skeleton.UtilityModule] = [.logger(),
                                                                  .dependencyContainer(),
                                                                  .streams(),
                                                                  .dataStructures()]

@MainActor public let featureModules: [Skeleton.FeatureModule] = [.onboarding(), .appSettings()]

@MainActor public let testModules: [Skeleton.TestModule] = [.coreTesting()]

@MainActor public let appModules: [any AppModule] = [Skeleton.ModularApp.app()]

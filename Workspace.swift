import ProjectDescription
import ProjectDescriptionHelpers
import SkeletonPlugin

@MainActor let workspace = Workspace.workspace(projectName: Constants.projectName,
                                               modules: utilityModules + coreModules + deviceCapabilityModules + featureModules + appModules,
                                               testModules: testModules)

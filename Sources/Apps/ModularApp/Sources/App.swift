import DesignSystem
import Onboarding
import SwiftUI
import UIKit

@main
struct App: SwiftUI.App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    var appState: AppState { appDelegate.container.state }
//    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            VStack {
                if appState.isConfigured {
                    PillButton("Click me", style: .init(foregroundColor: "#FFCC00",
                                                        backgroundColor: Color.clear,
                                                        showArrow: true)) {
                        await appState.router.send(NavigationRouteDefinition())
                    }
                    // OnboardingView(viewModel: OnboardingView.ViewModel())
                } else {
                    ZStack {
                        LaunchScreenView().ignoresSafeArea()
                        ProgressView()
                    }
                }
            }
            .modal()
            .navigationStack(router: appState.router)
            .environment(\.design, Design.shared)
        }
    }
}

#Preview(traits: .design(.app)) {
    OnboardingView(viewModel: OnboardingView.ViewModel())
}

public extension DesignPreviewModifier.Customization {
    static var app: Self {
        .init {
            $0.setup()
        }
    }
}

public struct LaunchScreenView: UIViewControllerRepresentable {
    let name: String
    let bundle: Bundle
    var showLogo: Bool
    public init(name: String = "LaunchScreen",
                bundle: Bundle = .main,
                showLogo: Bool = true) {
        self.name = name
        self.bundle = bundle
        self.showLogo = showLogo
    }

    public func makeUIViewController(context _: Context) -> UIViewController {
        UIStoryboard(name: name, bundle: bundle).instantiateInitialViewController() ?? .init()
    }

    public func updateUIViewController(_ viewController: UIViewController, context _: Context) {
        viewController.view.subviews.last?.isHidden = !showLogo
    }
}

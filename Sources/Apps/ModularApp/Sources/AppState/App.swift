import Components
import DesignSystem
import Onboarding
import Routes
import SwiftUI
import UIKit

@main
struct App: SwiftUI.App {
    @UIApplicationDelegateAdaptor var appDelegate: AppDelegate
    var appState: AppState { appDelegate.container.state }

    var body: some Scene {
        WindowGroup {
            StateView()
                .environment(\.appState, appState)
                .environment(\.design, Design.shared)
        }
    }
}

extension App {
    struct StateView: View {
        @Environment(\.design) var design: DesignSystem.Design
        @Environment(\.appState) var appState: AppState

        var body: some View {
            ZStack {
                Color.clear.ignoresSafeArea()
                switch appState.state {
                case .home:
                    TabView {
                        ZStack {
                            Color.red.ignoresSafeArea()
                            PillButton("Click me - I pretend to be the home screen :)",
                                       style: .init(foregroundColor: "#FFCC00",
                                                    backgroundColor: SwiftUI.Color.clear,
                                                    showArrow: true)) {
                                //                        await appState.router.send(OnboardingRouteDefinition(message: "ciao dalla home"))
                                appState.router.send(.appSettings())
                                //                        await appState.router.send(.webRoute("https://www.google.com"))
                            }
                        }.tabItem {
                            Text("Home")
                        }

                    }.tabViewStyle(.automatic)
                        .navigationStack(router: appState.router)
                case .launching:
                    ZStack {
                        LaunchScreenView().ignoresSafeArea()
                        ProgressView()
                            .foregroundStyle(.white)
                            .padding(32)
                            .background(Color.black.opacity(0.5))
                            .cornerRadius(8)
                    }
                }
            }
        }
    }
}

@MainActor
struct AppStateKey: @MainActor EnvironmentKey {
    static let defaultValue: AppState = .empty
}

extension EnvironmentValues {
    @MainActor var appState: AppState {
        get { self[AppStateKey.self] }
        set { self[AppStateKey.self] = newValue }
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

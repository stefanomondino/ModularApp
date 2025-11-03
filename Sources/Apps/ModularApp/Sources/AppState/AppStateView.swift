import Components
import DesignSystem
import Onboarding
import Routes
import SwiftUI
import UIKit

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
                            Pill.Button("Click me - I pretend to be the home screen :)",
                                        style: .standard) {
                                //                        await appState.router.send(OnboardingRouteDefinition(message: "ciao dalla home"))
                                appState.goToAppSettings()
//                                appState.router.send(.webRoute("https://www.google.com"))
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
            }.overlay {
                if appState.isLocked {
                    ZStack {
                        Color.red.ignoresSafeArea()
                        VStack {
                            Text("Locked")
                            Button(action: {
                                appState.unlock()
                            }, label: {
                                Text("Unlock")
                            })
                        }
                    }
                }
            }
        }
    }
}

#Preview(traits: .design(.app)) {
    OnboardingView(viewModel: OnboardingView.ViewModel())
}

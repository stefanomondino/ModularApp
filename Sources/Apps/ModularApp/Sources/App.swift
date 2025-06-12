import DesignSystem
import Onboarding
import SwiftUI
import UIKit

@main
struct App: SwiftUI.App {
    @Environment(\.scenePhase) var scenePhase
    var body: some Scene {
        WindowGroup {
            VStack {
                OnboardingView(viewModel: OnboardingView.ViewModel())

            }.environment(\.design, Design.shared)
        }.onChange(of: scenePhase, initial: true) { _, newPhase in
            // Monitoring the app's lifecycle changes
//            guard oldPhase != newPhase else { return }
            switch newPhase {
            case .active:
                Design.shared.setup()
            case .inactive:
                Design.shared.setup()
            case .background:
                print("App is in the background")
            @unknown default:
                print("Unknown state")
            }
        }
    }
}

struct ContentView: View {
    var body: some View {
        TestView()
    }
}

#Preview {
    ContentView()
}

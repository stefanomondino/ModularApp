import Components
import DesignSystem
import Onboarding
import Routes
import SwiftUI
import UIKit

extension App {
    struct LifecycleView: View {
        @Environment(\.design) var design: DesignSystem.Design
        @Environment(\.appState) var appState: AppLifecycle

        var body: some View {
            LaunchScreenView().ignoresSafeArea()
                .restartable()
                .environment(\.router, appState.router)
        }
    }
}

#Preview(traits: .design(.app)) {
    OnboardingView(viewModel: OnboardingView.ViewModel())
}

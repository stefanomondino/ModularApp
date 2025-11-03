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
            ZStack {
                Color.clear.ignoresSafeArea()
                if let viewModel = appState.startViewModel {
                    StartView(viewModel: viewModel)
                } else {
                    LaunchScreenView().ignoresSafeArea()
                    ProgressView()
                        .foregroundStyle(.white)
                        .padding(32)
                        .background(Color.red.opacity(0.5))
                        .cornerRadius(8)
                }
            }
        }
    }
}

#Preview(traits: .design(.app)) {
    OnboardingView(viewModel: OnboardingView.ViewModel())
}

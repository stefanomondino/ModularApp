import DesignSystem
import SwiftUI

public struct OnboardingView: View {
    @Environment(\.design) var design
    @State var viewModel: OnboardingViewModel

    public init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        VStack {
            Text("Welcome to the Onboarding Screen")
                .typography(design.typography.h1)
                .foregroundColor(design.color.primary)
                .accessibilityLabel("Welcome")
                .accessibilityHidden(true)
//            Text(design.typography.onboardingCustomTitle.temporaryValue)
            Text(viewModel.title)
                .typography(design.typography.h1)
                .foregroundColor(design.color.background)
            Button(action: {
                       withAnimation {
                           viewModel.onTap()
                       }
                   },
                   label: { Text("Tap Me") })
        }
    }
}

// sourcery: AutoMockable
@MainActor public protocol OnboardingViewModel {
    var title: String { get }
    func onTap()
}

public extension OnboardingView {
    @Observable
    @MainActor final class ViewModel: OnboardingViewModel {
        public var title: String = "Onboarding Title"
        public init() {}

        public func onTap() {
            Design.shared.typography.register(for: .h1) {
                Typography(family: .code,
                           weight: .black,
                           size: .init(integerLiteral: (24 ... 50).randomElement() ?? 24),
                           textCase: .uppercase)
            }

//            title = ["Onboarding Title", "New Title"].randomElement() ?? "Default Title"
        }
    }
}

#Preview(traits: .design) {
    let viewModel = OnboardingView.ViewModel()
//    viewModel.title = "Preview Title"

    return OnboardingView(viewModel: viewModel)
}

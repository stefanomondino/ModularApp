import DesignSystem
import SwiftUI

public struct OnboardingView: View {
    @Environment(\.design) var design
    @State var viewModel: OnboardingViewModel

    public init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        ZStack {
            Color.clear
                .backgroundColor(.background)
                .ignoresSafeArea()
            VStack {
                Text("Welcome to the Onboarding Screen")
                    .typography(.h1)
                    .foregroundColor(.primary)
                    .backgroundColor(.secondary)
                    .accessibilityLabel("Welcome")
                    .accessibilityHidden(true)
                //            Text(design.typography.onboardingCustomTitle.temporaryValue)
                Text(viewModel.title)
                    .typography(.h2)
                    .foregroundColor(design.color.primary)
                PillButton("Try me",
                           style: .init(foregroundColor: design.color.primary,
                                        backgroundColor: design.color.secondary,
                                        showArrow: true),
                           action: {
                               withAnimation {
                                   viewModel.onTap()
                               }
                           })
            }
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
        public var title: String
        public init(message: String = "Onboarding Title") {
            title = message
        }

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

#Preview(traits: .design(.baseTypography)) {
    let viewModel = OnboardingView.ViewModel()
//    viewModel.title = "Preview Title"

    return OnboardingView(viewModel: viewModel)
}

import Routes

public struct OnboardingRouteDefinition: RouteDefinition, Equatable {
    public let identifier: String = UUID().uuidString
    let message: String
    public init(message: String) {
        self.message = message
    }
}

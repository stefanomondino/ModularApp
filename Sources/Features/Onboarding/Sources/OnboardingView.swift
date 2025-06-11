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
//            Text(design.typography.onboardingCustomTitle.temporaryValue)
            Text(viewModel.title)

            Button(action: { viewModel.onTap() },
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
            title = ["Onboarding Title", "New Title"].randomElement() ?? "Default Title"
        }
    }
}

public extension Typography.Key {
    static var onboardingCustomTitle: Self { "onboardingCustomTitle" }
}

#Preview(traits: .design) {
    let viewModel = OnboardingViewModelMock()
    viewModel.title = "Preview Title"

    return OnboardingView(viewModel: viewModel)
}

public extension PreviewTrait where T == Preview.ViewTraits {
    static var design: Self {
        if #available(iOS 18.0, *) {
            .modifier(DesignPreviewModifier())
        } else {
            .sizeThatFitsLayout
        }
    }
}

public struct DesignPreviewModifier: PreviewModifier {
    public static func makeSharedContext() async throws -> DesignSystem.Design {
        let design = DesignSystem.Design()

//        design.typography.register(for: .onboardingCustomTitle) {
//            Typography(value: "Preview Custom Title from traits")
//        }

        return design
    }

    public func body(content: Content, context: Design) -> some View {
        content.environment(\.design, context)
    }
}

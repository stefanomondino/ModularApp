import Components
import DesignSystem
import SwiftUI

public struct OnboardingItem {
    var image: String
    var title: String
    var subtitle: String
    var buttonTitle: String
    var selectedPage: Int
}

// sourcery: AutoMockable
@MainActor public protocol OnboardingViewModel {
    var pages: [(item: OnboardingItem, action: (() -> Void)?)] { get }
}

public struct OnboardingView: View {
    @State var viewModel: OnboardingViewModel

    public init(viewModel: OnboardingViewModel) {
        self.viewModel = viewModel
    }
    
    @State var currentItem = 0
    
    public var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            TabView(selection: $currentItem) {
                ForEach(viewModel.pages, id: \.item.selectedPage) { item in
                    OnboardingDetailView(item: item.item,
                                     next: $currentItem,
                                     count: viewModel.pages.count) {
                        print("End")
                    } didActivateAction: {
                        item.action?()
                    }

                }
                .toolbar(.hidden, for: .tabBar)
            }
        }
    }
}

public extension OnboardingView {
    @Observable
    @MainActor
    final class ViewModel: OnboardingViewModel {
        public var pages: [(item: OnboardingItem, action: (() -> Void)?)] = []

        public init() { }
    }
}

enum OnboardingFactory {
    static func makeItem(image: String,
                         title: String,
                         subtitle: String,
                         nextTitle: String, action: (() -> Void)?) -> (item: OnboardingItem, action: (() -> Void)?) {
        (OnboardingItem(image: image,
                       title: title,
                       subtitle: subtitle,
                       buttonTitle: nextTitle,
                       selectedPage: 0),
         action)    
    }
    
    @MainActor
    static func makeOnboardingView(items: [(item: OnboardingItem, action: (() -> Void)?)],
                                   viewModel: OnboardingView.ViewModel) -> OnboardingView {
        viewModel.pages = items.enumerated().map { (offset, item) in
            var newItem: OnboardingItem = item.item
            newItem.selectedPage = offset
            
            return (newItem, item.action)
        }
        
        return OnboardingView(viewModel: viewModel)
        
    }
    
    @MainActor
    static func makeOnboardingDetailView(item: OnboardingItem,
                                         next: Binding<Int>,
                                         total: Int) -> OnboardingDetailView {
        OnboardingDetailView(item: item, next: next, count: total)
    }
}

#Preview {
    let viewModel = OnboardingView.ViewModel()
    
    var pages = [
        OnboardingFactory.makeItem(image: "star.fill",
                                   title: "Prima Page",
                                   subtitle: "sub 1",
                                   nextTitle: "Avanti",
                                   action: { print("Step 1") }),
        OnboardingFactory.makeItem(image: "square.fill",
                                   title: "Seconda page",
                                   subtitle: "sub2 ",
                                   nextTitle: "Avanti",
                                   action: { print("Step 2") }),
        OnboardingFactory.makeItem(image: "triangle.fill",
                                   title: "Last page",
                                   subtitle: "sub 3",
                                   nextTitle: "Entra in app",
                                   action: { print("Step 3") })
    ]
    
    OnboardingFactory.makeOnboardingView(items: pages, viewModel: viewModel)
}

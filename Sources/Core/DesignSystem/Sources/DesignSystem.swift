import DependencyContainer
import SwiftUI

@Observable
public final class Design: MainActorProvider {
    @MainActor public var provider: MainActorTypeProvider = [:]

    public static let shared = Design()

    public init() {}

    @MainActor public var typography: Typography.Provider {
        resolve(default: .init())
    }

    @MainActor public var color: Color.Provider {
        resolve(default: .init())
    }
}

public extension EnvironmentValues {
    @Entry var design: Design = .shared
}

public struct TestView: View {
    @Environment(\.design) var design
    public init() {}
    public var body: some View {
        VStack {
            Text("Ciao")
                .typography(design.typography.h1)
                .foregroundColor(design.color.primary)
            Text("Ciao ma fisso")
                .typography(design.typography.body, dynamic: false)
        }
//        .task {
//            design.typography.register(for: .h1) {
//                Typography(family: .system, weight: .bold, size: 24)
//            }
//        }
    }
}

#Preview(traits: .design) {
    TestView()
}

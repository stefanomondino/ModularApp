import DependencyContainer
import SwiftUI

public final class Design: MainActorProvider {
    @MainActor public var provider: MainActorTypeProvider = [:]

    var name: String { "Design system" }
    public static let shared = Design()

    public init() {}

    @MainActor public var typography: Typography.Provider {
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
        }
    }
}

#Preview {
    TestView()
}

import DependencyContainer
import SwiftUI

@Observable
public final class Design: MainActorProvider {
    @MainActor public var provider: MainActorTypeProvider = [:]

    public static let shared = Design()

    public init() {}

    @MainActor public func update(_ callback: (Design) -> Void) {
        callback(self)
    }

    @MainActor public var typography: Typography.Provider {
        resolve(default: .init())
    }

    @MainActor public var value: NumberValue.Provider {
        resolve(default: .init())
    }

    @MainActor public var color: Color.Provider {
        resolve(default: .init())
    }
}

public extension EnvironmentValues {
    @Entry var design: Design = .shared
}

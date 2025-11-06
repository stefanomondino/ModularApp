import DependencyContainer
import SwiftUI
import Streams

@Observable @MainActor
public final class Design: MainActorProvider {

    public enum ColorMode: String, Sendable, Codable {
        case light
        case dark
        case system
    }
    @MainActor public var storage: MainActorTypeStorage = .init()
    
    private let colorMode = Property<ColorMode>(.userDefaults("colorMode", defaultValue: .system))
    
    public init() {
        Task {
            for await mode in colorMode {
                switch mode {
                case .light:
                    self.colorScheme = .light
                case .dark: self.colorScheme = .dark
                case .system:
                    self.colorScheme = nil
                }
            }
        }
    }
    public func updateSystemColorScheme(_ scheme: ColorScheme) {
        if colorMode.value == .system {
            self.colorScheme = scheme
        }
    }
    public var colorScheme: ColorScheme?
        
    @MainActor public func update(_ callback: (Design) -> Void) {
        callback(self)
    }

    @MainActor public var typography: Typography.Provider {
        resolve(default: .init())
    }

    @MainActor public var value: NumberValue.Provider {
        resolve(default: .init())
    }
    
    @MainActor public var lightColor: Color.LightProvider {
        resolve(default: .init())
    }
    @MainActor public var darkColor: Color.DarkProvider {
        resolve(default: .init())
    }
    
    @MainActor public var color: any Color.Provider {
        if colorScheme == .dark {
            darkColor
        } else {
            lightColor
        }
    }

    @MainActor public var asset: Image.Provider {
        resolve(default: .init())
    }
}

//
//  Property+UserDefaults.swift
//  Streams
//
//  Created by Stefano Mondino on 23/10/25.
//

import Foundation

public extension Property {
    struct UserDefaultsParameters: Sendable {
        public let key: String
        public let userDefaults: @Sendable () -> UserDefaults

        public init(_ key: String, userDefaults: @Sendable @escaping () -> UserDefaults = { .standard }) {
            self.key = key
            self.userDefaults = userDefaults
        }
    }

    static func userDefaults(_ key: String,
                             defaultValue: Element,
                             userDefaults: @Sendable @autoclosure @escaping () -> UserDefaults = .standard,
                             get: @Sendable @escaping (Data) -> Element,
                             set: @Sendable @escaping (Element) -> Data) -> Strategy {
        self.userDefaults(parameters: .init(key, userDefaults: userDefaults),
                          defaultValue: defaultValue,
                          get: get,
                          set: set)
    }

    static func userDefaults(_ key: String,
                             defaultValue: Element,
                             userDefaults: @Sendable @autoclosure @escaping () -> UserDefaults = .standard) -> Strategy where Element: Codable {
        self.userDefaults(parameters: .init(key, userDefaults: userDefaults),
                          defaultValue: defaultValue,
                          get: { (try? JSONDecoder().decode(Element.self, from: $0)) },
                          set: { try? JSONEncoder().encode($0) })
    }

    private static func userDefaults(parameters: UserDefaultsParameters,
                                     defaultValue: Element,
                                     get: @Sendable @MainActor @escaping (Data) -> Element?,
                                     set: @Sendable @MainActor @escaping (Element) -> Data?) -> Strategy {
        .custom(get: {
            guard let data = parameters.userDefaults()[data: parameters.key] else {
                return defaultValue
            }
            return get(data) ?? defaultValue
        }, set: { newValue in
            let data = set(newValue)
            parameters.userDefaults()[data: parameters.key] = data
        })
    }
}

private extension UserDefaults {
    subscript(data key: String) -> Data? {
        get {
            value(forKey: key) as? Data
        }
        set {
            set(newValue, forKey: key)
        }
    }
}

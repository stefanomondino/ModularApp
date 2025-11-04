//
//  SwiftUIGenericRoute.swift
//  Routes
//
//  Created by Stefano Mondino on 31/10/25.
//

import Foundation
import SwiftUI

public enum SwiftUINavigationTag {}
public typealias SwiftUINavigationRoute = SwiftUIGenericRoute<SwiftUINavigationTag>

public enum SwiftUIModalTag {}
public typealias SwiftUIModalRoute = SwiftUIGenericRoute<SwiftUIModalTag>

public enum SwiftUIRestartTag {}
public typealias SwiftUIRestartRoute = SwiftUIGenericRoute<SwiftUIRestartTag>

public struct SwiftUIGenericRoute<Tag>: SwiftUIRoute, RouteDefinition, Sendable {
    public let identifier: String

    public func isSameRoute(as _: any RouteDefinition) -> Bool {
        false
    }

    public let view: @MainActor @Sendable () -> AnyView
    public init(identifier: String = UUID().uuidString,
                _ view: @MainActor @Sendable @escaping () -> any View) {
        self.identifier = identifier
        self.view = { AnyView(view()) }
    }
}

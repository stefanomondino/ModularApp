//
//  OnboardingRouteDefinition.swift
//  Onboarding
//
//  Created by Stefano Mondino on 04/11/25.
//

import Foundation
import Routes

public struct OnboardingRouteDefinition: RouteDefinition, Equatable {
    public let identifier: String = UUID().uuidString
    public init() {}
}

public extension Router.Identifier {
    static func onboarding() -> Self {
        .init(OnboardingRouteDefinition())
    }
}

//
//  RestartRouteDefinition.swift
//  Routes
//
//  Created by Stefano Mondino on 04/11/25.
//

public struct RestartRouteDefinition: RouteDefinition, Equatable {
    public let identifier: String = "restart"
    public init() {}
}

public extension Router.Identifier {
    static func restart() -> Self {
        .init(RestartRouteDefinition())
    }
}

//
//  BackRouteDefinition.swift
//  Routes
//
//  Created by Stefano Mondino on 31/10/25.
//

public struct BackRouteDefinition: RouteDefinition, Equatable {
    public enum BackType: Equatable, Sendable {
        case single
        case root
        case count(Int)
        case identifier(String)
    }

    public let identifier: String = "back"
    let backType: BackType
    public init(backType: BackType = .single) {
        self.backType = backType
    }
}

//
//  Feature.swift
//  Routes
//
//  Created by Stefano Mondino on 17/06/25.
//

import DependencyContainer

@MainActor
public protocol Feature: DependencyContainer where DependencyKey == ObjectIdentifier {
    associatedtype Container: DependencyContainer
    var services: [Service] { get async }
    init(_ container: Container) async
}

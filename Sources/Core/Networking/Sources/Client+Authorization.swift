//
//  Client+Authorization.swift
//  Networking
//
//  Created by Stefano Mondino on 25/06/25.
//
import Streams

public protocol AuthorizationMiddleware: Sendable {
    func createAuthorizationHeaders(from request: Request) async throws(NetworkingError) -> [Request.Header: String]
    func refresh(with client: Client, currentResponse: Response) async throws(NetworkingError) -> Bool
}

public struct EmptyAuthorizationMiddleware: AuthorizationMiddleware {
    public init() {}
    public func createAuthorizationHeaders(from _: Request) async throws(NetworkingError) -> [Request.Header: String] {
        [:]
    }

    public func refresh(with _: Client, currentResponse _: Response) async throws(NetworkingError) -> Bool {
        false
    }
}

public actor TokenAuthorizationMiddleware<Token: Sendable & Codable>: AuthorizationMiddleware {
    let storage: Property<Token?>
    let headers: @Sendable (Request, Token?) -> [Request.Header: String]
    let refreshPolicy: @Sendable (Client, Response) async throws(NetworkingError) -> Bool
    public init(token: Property<Token?>,
                headers: @Sendable @escaping (Request, Token?) -> [Request.Header: String] = { _, _ in [:] },
                refresh: @Sendable @escaping (Client, Response) async throws(NetworkingError) -> Bool = { _, _ in false })
    {
        storage = token
        self.headers = headers
        refreshPolicy = refresh
    }

    public func createAuthorizationHeaders(from request: Request) async throws(NetworkingError) -> [Request.Header: String] {
        await headers(request, storage.value)
    }

    public func refresh(with client: Client, currentResponse: Response) async throws(NetworkingError) -> Bool {
        try await refreshPolicy(client, currentResponse)
    }
}

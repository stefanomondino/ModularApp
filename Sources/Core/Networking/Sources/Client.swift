//
//  Client.swift
//  Networking
//
//  Created by Stefano Mondino on 23/06/25.
//

import Foundation
import Streams

public actor Client {
    let session: URLSession
    let mocker = Mocker()
    let authorization: AuthorizationMiddleware
    private var cache: [Request: Signal<Result<Response, NetworkingError>>] = [:]
    public init(session: URLSession? = nil,
                authorization: AuthorizationMiddleware = EmptyAuthorizationMiddleware())
    {
        self.session = session ?? URLSession(configuration: .default)
        self.authorization = authorization
    }

    private func buildURLRequest(from request: Request) async throws(NetworkingError) -> URLRequest {
        guard var components = URLComponents(url: request.baseURL, resolvingAgainstBaseURL: false) else {
            throw .invalidRequest(request)
        }
        components.path = request.path.description
        if request.queryParameters.isEmpty == false {
            components.queryItems = request.queryParameters.queryItems
        }
        guard let url = components.url else {
            throw NetworkingError.invalidRequest(request)
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.description
        urlRequest.httpBody = request.body
        try await urlRequest.allHTTPHeaderFields = request.httpHeaders
            .merging(authorization.createAuthorizationHeaders(from: request)) { _, second in second }
            .reduce(into: [:]) { $0[$1.key.description] = $1.value }
        return urlRequest
    }

    private func processHTTPResponse(_ response: Response) async throws(NetworkingError) -> Response {
        if try await authorization.refresh(with: self, currentResponse: response) {
            cache[response.request] = nil
            return try await self.response(response.request).filterHTTPErrors()
        } else {
            return try response.filterHTTPErrors()
        }
    }

    public func response(_ request: Request) async throws(NetworkingError) -> Response {
        if let mockedResponse = await mockedResponse(for: request) {
            return mockedResponse
        }
        if let cachedResponse = cache[request] {
            for await result in cachedResponse.prefix(1) {
                switch result {
                case let .success(response):
                    return response
                case let .failure(error):
                    throw error
                }
            }
        }
        let signal = Signal<Result<Response, NetworkingError>>()
        var signalResult: Result<Response, NetworkingError>
        cache[request] = signal
        do {
            let (result, httpResponse) = try await session.data(for: buildURLRequest(from: request))
            if let httpResponse = httpResponse as? HTTPURLResponse {
                let processedResponse = try await processHTTPResponse(Response(result, response: httpResponse, request: request))
                signalResult = .success(processedResponse)
            } else {
                signalResult = .failure(NetworkingError.invalidResponse(httpResponse))
            }
        } catch {
            switch error {
            case let error as NetworkingError: signalResult = .failure(error)
            default: signalResult = .failure(.connectionError(request))
            }
        }

        cache[request] = nil
        await signal.send(signalResult)
        switch signalResult {
        case let .success(response):
            return response
        case let .failure(error):
            throw error
        }
    }
}

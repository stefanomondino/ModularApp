//
//  Client.swift
//  Networking
//
//  Created by Stefano Mondino on 23/06/25.
//

import Foundation

public actor Client {
    let session: URLSession
    let mocker = Mocker()
    public init(session: URLSession? = nil) {
        self.session = session ?? URLSession(configuration: .default)
    }

    private func buildURLRequest(from request: Request) throws(NetworkingError) -> URLRequest {
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
        return urlRequest
    }

    public func response(_ request: Request) async throws(NetworkingError) -> Response {
        if let mockedResponse = await mockedResponse(for: request) {
            return mockedResponse
        }
        do {
            let (result, httpResponse) = try await session.data(for: buildURLRequest(from: request))
            guard let httpResponse = httpResponse as? HTTPURLResponse else {
                throw NetworkingError.invalidResponse(httpResponse)
            }

            return .init(data: result, response: httpResponse)
        } catch {
            switch error {
            case let error as NetworkingError: throw error
            default: throw .invalidResponse(request, underlyingError: error)
            }
        }
    }

    public func response<Value: Decodable & Sendable>(_ json: Request.JSON<Value>) async throws(NetworkingError) -> Response.JSON<Value> {
        let response = try await self.response(json.request)
        return Response.JSON<Value>(response: response, decoder: json.decoder)
    }
}

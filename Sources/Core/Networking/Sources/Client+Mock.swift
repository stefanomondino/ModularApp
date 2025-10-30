//
//  Client+Mock.swift
//  Networking
//
//  Created by Stefano Mondino on 23/06/25.
//

import DependencyContainer
import Foundation

public extension Client {
    @NetworkingActor
    internal final class Mocker: DependencyContainer {
        var container: Container<Request> = .init()
        func clear() async {
            container = .init()
        }
    }

    func mock(for request: Request, response: @autoclosure @Sendable @escaping () throws -> Response?) async {
        await mocker.register(for: request) {
            try? response()
        }
    }

    func mock(for request: Request,
              data: DataConvertible,
              statusCode: Response.StatusCode = .ok,
              headers: [String: String] = [:]) async throws {
        try await mocker.register(for: request) {
            try Response(data.asData(), statusCode: statusCode, headers: headers, request: request)
        }
    }

    internal func mockedResponse(for request: Request) async -> Response? {
        await mocker.resolve(request, type: Response.self)
    }

    func clearMocks() async {
        await mocker.clear()
    }
}

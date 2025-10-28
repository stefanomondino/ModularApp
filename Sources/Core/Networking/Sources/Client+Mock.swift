//
//  Client+Mock.swift
//  Networking
//
//  Created by Stefano Mondino on 23/06/25.
//

import DependencyContainer

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

    internal func mockedResponse(for request: Request) async -> Response? {
        await mocker.resolve(request, type: Response.self)
    }

    func clearMocks() async {
        await mocker.clear()
    }
}

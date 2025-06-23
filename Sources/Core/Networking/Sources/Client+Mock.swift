//
//  Client+Mock.swift
//  Networking
//
//  Created by Stefano Mondino on 23/06/25.
//

import DependencyContainer

public extension Client {
    internal actor Mocker: DependencyContainer {
        var container: Container<Request> = .init()
        func clear() async {
            container = .init()
        }
    }

    func mock(for request: Request, response: @autoclosure @Sendable @escaping () -> Response?) async {
        await mocker.register(for: request) {
            response()
        }
    }

    func mockedResponse(for request: Request) async -> Response? {
        await mocker.resolve(request, type: Response.self)
    }

    func clearMocks() async {
        await mocker.clear()
    }
}

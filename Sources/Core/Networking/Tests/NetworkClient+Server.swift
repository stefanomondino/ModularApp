//
//  NetworkClient+Server.swift
//  NetworkingTests
//
//  Created by Stefano Mondino on 23/06/25.
//

import FlyingFox
import Foundation
import Networking

@ServerActor
class Server: Sendable {
    let server: HTTPServer
    fileprivate init(port: UInt16) async throws {
        server = HTTPServer(port: port)
    }

    func register(_ response: Response, for request: Request, delay: TimeInterval = 0) async throws {
        await server.appendRoute(HTTPRoute(method: .init(rawValue: request.method.description),
                                           path: request.path.description)) { _ in
            if delay > 0 {
                try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
            }
            return HTTPResponse(statusCode: .init(response.statusCode.rawValue, phrase: ""),
                                headers: .init(response.headers.map { (HTTPHeader($0.key), $0.value) }, uniquingKeysWith: { _, last in last }),
                                body: response.data)
        }
    }
}

@globalActor actor ServerActor: GlobalActor {
    static let shared: ServerActor = .init()
    init() {}
}

func withServer(port: UInt16 = 8083, _ callback: @Sendable @escaping @ServerActor (Server) async throws -> Void) async throws {
    let server = try await Server(port: port)
    Task { try await server.server.run() }
    try await server.server.waitUntilListening(timeout: 3.0)
    try await callback(server)
    await server.server.stop()
}

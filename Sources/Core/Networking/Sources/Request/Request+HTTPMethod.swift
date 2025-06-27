//
//  Request+HTTPMethod.swift
//  Networking
//
//  Created by Stefano Mondino on 27/06/25.
//

public extension Request {
    enum HTTPMethod: String, Sendable, CustomStringConvertible {
        public var description: String { rawValue }

        /// `CONNECT` method.
        case connect = "CONNECT"
        /// `DELETE` method.
        case delete = "DELETE"
        /// `GET` method.
        case get = "GET"
        /// `HEAD` method.
        case head = "HEAD"
        /// `OPTIONS` method.
        case options = "OPTIONS"
        /// `PATCH` method.
        case patch = "PATCH"
        /// `POST` method.
        case post = "POST"
        /// `PUT` method.
        case put = "PUT"
        /// `TRACE` method.
        case trace = "TRACE"

        var allowsBody: Bool {
            [.get, .head, .options, .trace].contains(self) == false
        }
    }
}

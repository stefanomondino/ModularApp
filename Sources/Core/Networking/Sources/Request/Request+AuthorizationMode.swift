//
//  AuthorizationMode.swift
//  Networking
//
//  Created by Stefano Mondino on 27/06/25.
//
import DataStructures

public extension Request {
    struct AuthorizationMode: ExtensibleIdentifierType, ExpressibleByStringInterpolation {
        public let value: String

        public init(_ value: String) {
            self.value = value
        }

        public init(stringLiteral value: String) {
            self.value = value
        }

        public static var none: Self { "" }
        public static var basic: Self { "Basic" }
        public static var bearer: Self { "Bearer" }
    }

    struct Header: ExtensibleIdentifierType, ExpressibleByStringInterpolation {
        public let value: String

        public init(_ value: String) {
            self.value = value
        }

        public init(stringLiteral value: String) {
            self.value = value
        }

        public static var authorization: Self { "Authorization" }
        public static var contentType: Self { "Content-Type" }
        public static var accept: Self { "Accept" }
        public static var userAgent: Self { "User-Agent" }
        public static var host: Self { "Host" }
        public static var contentLength: Self { "Content-Length" }
        public static var contentEncoding: Self { "Content-Encoding" }
        public static var contentDisposition: Self { "Content-Disposition" }
        public static var connection: Self { "Connection" }
        public static var upgrade: Self { "Upgrade" }
        public static var range: Self { "Range" }
    }
}

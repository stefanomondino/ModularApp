//
//  Response.swift
//  Networking
//
//  Created by Stefano Mondino on 23/06/25.
//
import Foundation

public struct Response: Sendable, Equatable {
    public struct StatusCode: RawRepresentable, Sendable, Equatable, Hashable, ExpressibleByIntegerLiteral, CustomStringConvertible {
        public var rawValue: Int
        public var description: String { rawValue.description }
        public init(_ value: Int) {
            rawValue = value
        }

        public init(integerLiteral value: Int) {
            self.init(value)
        }

        public init?(rawValue: Int) {
            self.init(rawValue)
        }

        public var isValid: Bool {
            rawValue < 400
        }

        public static var unauthorized: StatusCode { 401 }
        public static var forbidden: StatusCode { 403 }
        public static var notFound: StatusCode { 404 }
        public static var internalServerError: StatusCode { 500 }
        public static var badRequest: StatusCode { 400 }
        public static var ok: StatusCode { 200 }
        public static var created: StatusCode { 201 }
        public static var accepted: StatusCode { 202 }
        public static var noContent: StatusCode { 204 }
    }

    public let data: Data
    public let statusCode: StatusCode
    public let headers: [String: String]
    public let request: Request
    public init(_ data: Data, response: HTTPURLResponse, request: Request) {
        self.data = data
        self.request = request
        statusCode = .init(response.statusCode)
        headers = response.allHeaderFields.reduce(into: [:]) {
            if let value = ($1.value as? CustomStringConvertible)?.description {
                $0[$1.key.description] = value
            }
        }
    }

    public var contents: String? {
        String(bytes: data, encoding: .utf8)
    }

//    public init<Value: Encodable>(value: Value,
//                                  encoder: JSONEncoder = JSONEncoder(),
//                                  statusCode: StatusCode = 200,
//                                  headers: [String: String] = [:]) throws(NetworkingError) {
//        do {
//            let data = try encoder.encode(value)
//            try self.init(data, statusCode: statusCode, headers: headers)
//        } catch {
//            switch error {
//            case let error as NetworkingError: throw error
//            default: throw NetworkingError.encodingFailed(error)
//            }
//        }
//    }

    public init(_ data: DataConvertible, statusCode: StatusCode = 200, headers: [String: String] = [:], request: Request) throws(NetworkingError) {
        try self.init(data.asData(), statusCode: statusCode, headers: headers, request: request)
    }

    public init(_ data: String, statusCode: StatusCode = 200, headers: [String: String] = [:], request: Request) {
        self.data = Data(data.utf8)
        self.headers = headers
        self.statusCode = statusCode
        self.request = request
    }

    public init(_ data: Data, statusCode: StatusCode = 200, headers: [String: String] = [:], request: Request) {
        self.data = data
        self.headers = headers
        self.statusCode = statusCode
        self.request = request
    }

    public func filterHTTPErrors() throws(NetworkingError) -> Response {
        guard statusCode.isValid else {
            throw NetworkingError.httpError(self)
        }
        return self
    }
}

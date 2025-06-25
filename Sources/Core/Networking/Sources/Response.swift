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
    }

    public let data: Data
    public let statusCode: StatusCode
    public let headers: [String: String]

    public init(data: Data, response: HTTPURLResponse) {
        self.data = data
        statusCode = .init(response.statusCode)
        headers = response.allHeaderFields.reduce(into: [:]) {
            if let value = ($1.value as? CustomStringConvertible)?.description {
                $0[$1.key.description] = value
            }
        }
    }

    public init<Value: Encodable>(value: Value,
                                  encoder: JSONEncoder = JSONEncoder(),
                                  statusCode: StatusCode = 200,
                                  headers: [String: String] = [:]) throws(NetworkingError) {
        do {
            let data = try encoder.encode(value)
            try self.init(data: data, statusCode: statusCode, headers: headers)
        } catch {
            switch error {
            case let error as NetworkingError: throw error
            default: throw NetworkingError.encodingFailed(error)
            }
        }
    }

    public init(data: DataConvertible, statusCode: StatusCode = 200, headers: [String: String] = [:]) throws(NetworkingError) {
        try self.init(data: data.asData(), statusCode: statusCode, headers: headers)
    }

    public init(data: Data, statusCode: StatusCode = 200, headers: [String: String] = [:]) {
        self.data = data
        self.headers = headers
        self.statusCode = statusCode
    }
}

public protocol DataConvertible {
    func asData() throws(NetworkingError) -> Data
}

extension Data: DataConvertible {
    public func asData() throws(NetworkingError) -> Data {
        self
    }
}

extension String: DataConvertible {
    public func asData() throws(NetworkingError) -> Data {
        Data(utf8)
    }
}

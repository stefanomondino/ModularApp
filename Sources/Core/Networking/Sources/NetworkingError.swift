//
//  NetworkingError.swift
//  Networking
//
//  Created by Stefano Mondino on 23/06/25.
//
import DataStructures
import Foundation

public struct NetworkingError: Error, CustomStringConvertible, Equatable {
    public struct Code: ExtensibleIdentifierType, ExpressibleByIntegerLiteral {
        public let value: Int
        public init(_ value: Int) {
            self.value = value
        }

        public static var invalidRequest: Self { -1 }
        public static var invalidResponse: Self { -2 }
        public static var decodingError: Self { -3 }
        public static var encodingError: Self { -4 }
        public static var connection: Self { -5 }
        public static var http: Self { -6 }
        public static var unknown: Self { -999 }
    }

    public let message: String
    public let code: Code

    public var description: String {
        "NetworkingError(code: \(code), message: \(message))"
    }

    public static func invalidRequest(_ request: Request) -> NetworkingError {
        NetworkingError(message: "Invalid request: \(request)", code: .invalidRequest)
    }

    public static func invalidResponse(_ request: Request, underlyingError _: Error) -> NetworkingError {
        NetworkingError(message: "Invalid request: \(request)", code: .invalidResponse)
    }

    public static func invalidResponse(_ response: URLResponse) -> NetworkingError {
        NetworkingError(message: "Invalid response - not an HTTP response: \(response)", code: .invalidResponse)
    }

    public static func decodingError(_ error: Error) -> NetworkingError {
        NetworkingError(message: "Decoding error: \(error.localizedDescription)", code: .decodingError)
    }

    public static func encodingError(_ error: Error) -> NetworkingError {
        NetworkingError(message: "Encoding error: \(error.localizedDescription)", code: .encodingError)
    }

    public static func dataConversionError(_ error: Error) -> NetworkingError {
        NetworkingError(message: "Data conversion error: \(error.localizedDescription)", code: .decodingError)
    }

    public static func encodingFailed(_ error: Error) -> NetworkingError {
        NetworkingError(message: "Encoding failure: \(error.localizedDescription)", code: .encodingError)
    }

    public static func unknown(message: String = "Unknown error") -> NetworkingError {
        NetworkingError(message: message, code: .unknown)
    }

    public static func connectionError(_ request: Request) -> NetworkingError {
        NetworkingError(message: "Connection error for request \(request)", code: .connection)
    }

    public static func httpError(_ response: Response) -> NetworkingError {
        NetworkingError(message: "HTTP error \(response.statusCode) with response \(response)", code: .http)
    }
}

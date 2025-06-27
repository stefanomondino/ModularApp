//
//  NetworkingError.swift
//  Networking
//
//  Created by Stefano Mondino on 23/06/25.
//
import Foundation

public struct NetworkingError: Error, CustomStringConvertible, Equatable {
    let message: String
    let code: Int

    public var description: String {
        "NetworkingError(code: \(code), message: \(message))"
    }

    public static func invalidRequest(_ request: Request) -> NetworkingError {
        NetworkingError(message: "Invalid request: \(request)", code: -1)
    }

    public static func invalidResponse(_ request: Request, underlyingError _: Error) -> NetworkingError {
        NetworkingError(message: "Invalid request: \(request)", code: -1)
    }

    public static func invalidResponse(_ response: URLResponse) -> NetworkingError {
        NetworkingError(message: "Invalid response - not an HTTP response: \(response)", code: -1)
    }

    public static func decodingError(_ error: Error) -> NetworkingError {
        NetworkingError(message: "Decoding error: \(error.localizedDescription)", code: -2)
    }

    public static func encodingError(_ error: Error) -> NetworkingError {
        NetworkingError(message: "Encoding error: \(error.localizedDescription)", code: -3)
    }

    public static func dataConversionError(_ error: Error) -> NetworkingError {
        NetworkingError(message: "Data conversion error: \(error.localizedDescription)", code: -2)
    }

    public static func encodingFailed(_ error: Error) -> NetworkingError {
        NetworkingError(message: "Encoding failure: \(error.localizedDescription)", code: -3)
    }

    public static func unknown() -> NetworkingError {
        NetworkingError(message: "Unknown error", code: -999)
    }

    public static func connectionError(_ request: Request) -> NetworkingError {
        NetworkingError(message: "Connection error for request \(request)", code: -4)
    }

    public static func httpError(_ response: Response) -> NetworkingError {
        NetworkingError(message: "HTTP error \(response.statusCode) with response \(response)", code: -5)
    }
}

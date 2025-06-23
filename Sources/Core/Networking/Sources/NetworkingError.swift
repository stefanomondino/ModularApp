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
}

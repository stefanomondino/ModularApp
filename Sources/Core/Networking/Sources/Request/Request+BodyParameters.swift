//
//  Request+BodyParameters.swift
//  Networking
//
//  Created by Stefano Mondino on 27/06/25.
//

import Foundation

public extension Request {
    struct BodyParameters {
        let data: Data
        let headers: [Header: String]
        public init(data: Data, headers: [Header: String]) {
            self.data = data
            self.headers = headers
        }

        public static func json<JSON: Encodable>(_ object: JSON, encoder: JSONEncoder = .init()) throws(NetworkingError) -> Self {
            do {
                let data: Data = try encoder.encode(object)
                return .init(data: data, headers: [.contentType: "application/json"])
            } catch {
                throw NetworkingError.encodingError(error)
            }
        }

        public static func json(_ json: [String: Any]) throws(NetworkingError) -> Self {
            do {
                let data: Data = try JSONSerialization.data(withJSONObject: json, options: [])
                return .init(data: data, headers: [.contentType: "application/json"])
            } catch {
                throw NetworkingError.encodingError(error)
            }
        }

        public static func json(_ json: [Any]) throws(NetworkingError) -> Self {
            do {
                let data: Data = try JSONSerialization.data(withJSONObject: json, options: [])
                return .init(data: data, headers: [.contentType: "application/json"])
            } catch {
                throw NetworkingError.encodingError(error)
            }
        }
    }
}

public extension Data {
    func asBodyParameters(headers: [Request.Header: String] = [:]) -> Request.BodyParameters {
        Request.BodyParameters(data: self, headers: headers)
    }
}

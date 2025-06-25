//
//  JSON.swift
//  Networking
//
//  Created by Stefano Mondino on 23/06/25.
//
import Foundation

public extension Response {
    fileprivate struct JSON<Value: Decodable & Sendable>: Sendable {
        let response: Response
        let decoder: JSONDecoder
        public func value() throws(NetworkingError) -> Value {
            do {
                return try decoder.decode(Value.self, from: response.data)
            } catch {
                throw NetworkingError.decodingError(error)
            }
        }
    }

    func json<Value: Decodable & Sendable>(decoder: JSONDecoder = .init(), _: Value.Type = Value.self) throws(NetworkingError) -> Value {
        try JSON(response: self, decoder: decoder).value()
    }
}

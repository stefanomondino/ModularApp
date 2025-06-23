//
//  JSON.swift
//  Networking
//
//  Created by Stefano Mondino on 23/06/25.
//
import Foundation

public extension Request {
    struct JSON<Value: Decodable & Sendable>: Sendable {
        public let request: Request
        public let decoder: JSONDecoder
        public init(request: Request, decoder: JSONDecoder) {
            self.request = request
            self.decoder = decoder
        }
    }

    func json<Value: Decodable & Sendable>(decoder: JSONDecoder = .init(), _: Value.Type = Value.self) -> JSON<Value> {
        JSON(request: self, decoder: decoder)
    }
}

public extension Response {
    struct JSON<Value: Decodable & Sendable>: Sendable {
        let response: Response
        let decoder: JSONDecoder
        public func value() throws -> Value {
            try decoder.decode(Value.self, from: response.data)
        }
    }
}

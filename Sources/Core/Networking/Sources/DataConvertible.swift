//
//  DataConvertible.swift
//  Networking
//
//  Created by Stefano Mondino on 25/06/25.
//

import Foundation

public protocol DataConvertible: Sendable {
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

public extension DataConvertible where Self: Encodable {
    func asData() throws(NetworkingError) -> Data {
        let encoder = JSONEncoder()
        do {
            return try encoder.encode(self)
        } catch {
            throw NetworkingError.encodingError(error)
        }
    }
}

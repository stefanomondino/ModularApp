//
//  KeyDecodingContainer+Polymorph.swift
//
//
//  Created by Stefano Mondino on 13/09/24.
//

import Foundation

public extension KeyedDecodingContainer {
    /// Automatically used by Swift Decoder to decode a polymorphic type representing a nullable value  .
    func decode<Extractor, Value>(_ type: Polymorph<Extractor, Value>.Type, forKey key: K) throws -> Polymorph<Extractor, Value> where Value: ExpressibleByNilLiteral {
        if let value = try decodeIfPresent(type, forKey: key) {
            return value
        }
        return Polymorph()
    }
}

//
//  TypeExtractor.swift
//
//
//  Created by Stefano Mondino on 12/09/24.
//

import Foundation

/**
        An object capable of extracting a key type from a `Decodable` object
 */
public protocol TypeExtractor: Decodable, Equatable, Sendable {
    // having ObjectType: Polymorphic will compile the library but doesn't work when used in actual code with protocol
//    associatedtype ObjectType: Polymorphic
    associatedtype ObjectType: Sendable
    func itemType(from availableTypes: [any Polymorphic.Type]) -> (any Polymorphic.Type)?
    func extract(from container: SingleValueDecodingContainer,
                 availableTypes: [any Polymorphic.Type]) throws -> ObjectType?
    func extract(from container: inout UnkeyedDecodingContainer,
                 availableTypes: [any Polymorphic.Type]) throws -> ObjectType?
    static func extract(from decoder: any Decoder) throws -> ObjectType?
    static func extract(from decoder: any Decoder) throws -> [ObjectType]?
}

public protocol StringTypeExtractor: TypeExtractor,
    ExpressibleByStringInterpolation,
    CustomStringConvertible {
    var value: String { get }
    init(_ value: String)
}

extension Optional: Polymorphic where Wrapped: Polymorphic {
    public static var typeExtractor: Wrapped.Extractor {
        Wrapped.typeExtractor
    }
}

extension Array: Polymorphic where Element: Polymorphic {
    public static var typeExtractor: Element.Extractor {
        Element.typeExtractor
    }
}

extension Optional: TypeExtractor where Wrapped: TypeExtractor {
    public typealias ObjectType = Wrapped.ObjectType?
}

extension Array: TypeExtractor where Element: TypeExtractor {
    public typealias ObjectType = [Element.ObjectType]
}

public extension StringTypeExtractor {
    var description: String { value }
    init(stringInterpolation value: String) {
        self.init(value)
    }

    init(stringLiteral value: String) {
        self.init(value)
    }
}

public extension TypeExtractor {
    fileprivate static var codingReference: CodingUserInfoKey {
        .init(rawValue: "\(ObjectIdentifier(Self.self))").unsafelyUnwrapped
    }

    func itemType(from availableTypes: [any Polymorphic.Type]) -> (any Polymorphic.Type)? {
        availableTypes.first(where: { $0.typeExtractor as? Self == self })
    }

    func extract(from container: SingleValueDecodingContainer, availableTypes: [any Polymorphic.Type]) throws -> ObjectType? {
        if let type = itemType(from: availableTypes) {
            return try container.decode(type) as? ObjectType
        } else {
            return nil
        }
    }

    func extract(from container: inout UnkeyedDecodingContainer, availableTypes: [any Polymorphic.Type]) throws -> ObjectType? {
        if let type = itemType(from: availableTypes) {
            do {
                return try container.decode(type) as? ObjectType
            } catch {
                print("Error decoding \(type) from unkeyed container: \(error)")
                throw error
            }
        } else {
            return nil
        }
    }

    static func extract(from decoder: any Decoder) throws -> ObjectType? {
        let container = try decoder.singleValueContainer()
        let extractor = try container.decode(Self.self)

        if let object = try extractor
            .extract(from: container,
                     availableTypes: decoder.availableTypes(for: extractor)) {
            return object
        } else {
            return nil
        }
    }

    static func extract(from decoder: any Decoder) throws -> [ObjectType]? {
        var container = try decoder.unkeyedContainer()
        var objects: [Self.ObjectType] = []
        while !container.isAtEnd {
            // a copy is needed because every decoding on the unkeyed container "moves" the iteration
            // to the next element in the array.
            var decodingCopy = container
            let extractor = try container.decode(Self.self)
            if let value = try? extractor
                .extract(from: &decodingCopy,
                         availableTypes: decoder.availableTypes(for: extractor)) {
                objects.append(value)
            }
        }
        return objects
    }

    static func encode(value: ObjectType, into encoder: any Encoder) throws {
        if let value = value as? Encodable {
            var container = encoder.singleValueContainer()
            try container.encode(AnyEncodable(value))
        }
    }

    static func encode(values: [ObjectType], into encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()

        try values
            .compactMap { $0 as? Encodable }
            .forEach { object in
                try container.encode(AnyEncodable(object))
            }
    }
}

private struct AnyEncodable: Encodable {
    let value: Encodable
    init(_ value: Encodable) {
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try value.encode(to: &container)
    }
}

extension Encodable {
    func encode(to container: inout SingleValueEncodingContainer) throws {
        try container.encode(self)
    }
}

public extension Decoder {
    func availableTypes<Extractor: TypeExtractor>(for _: Extractor) -> [any Polymorphic.Type] {
        (userInfo[Extractor.codingReference] as? [any Polymorphic.Type]) ?? []
    }
}

public extension JSONDecoder {
    func set<Extractor: TypeExtractor>(types: [any Polymorphic.Type], for _: Extractor.Type = Extractor.self) {
        userInfo[Extractor.codingReference] = types
    }
}

public extension PropertyListDecoder {
    func set<Extractor: TypeExtractor>(types: [any Polymorphic.Type], for _: Extractor.Type = Extractor.self) {
        userInfo[Extractor.codingReference] = types
    }
}

public extension TypeExtractor {
    static func set(types: [any Polymorphic.Type], in decoder: JSONDecoder) {
        decoder.userInfo[codingReference] = types
    }
}

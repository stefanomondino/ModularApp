//
//  NullableValueTests.swift
//  DataStructuresTests
//
//  Created by Stefano Mondino on 23/06/25.
//

import CoreTesting
@testable import DataStructures
import Foundation
import Testing

@Suite("NullableValue Tests")
struct NullableValueTests {
    struct Mock: Codable {
        let id: String
        @NullableValue var title: String
    }

    @Test("JSON with null value should be parsed and have a default value")
    func nullValueGetsReplaced() throws {
        let values = try Stubs.nullableValuesStub.decode([Mock].self)
        let lastValue = try #require(values.last)
        #expect(values.count == 2)
        #expect(lastValue.id == "2")
        #expect(lastValue.title == "")
    }

    @Test("Encoding a NullableValue should not send nil on empty value")
    func nullValueDoesNotGetEncoded() throws {
        let encoder = JSONEncoder()
        let value: Mock = .init(id: "1", title: nil)
        let data = try encoder.encode(value)
        let dictionary = try #require(JSONSerialization.jsonObject(with: data) as? [String: Any])
        #expect(dictionary["id"] as? String == "1")
        #expect(dictionary["title"] == nil, "NullableValue should not be encoded when nil")
    }
}

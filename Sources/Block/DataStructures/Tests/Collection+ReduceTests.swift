//
//  Collection+ReduceTests.swift
//  DataStructuresTests
//
//  Created by Stefano Mondino on 30/10/25.
//

@testable import DataStructures
import Foundation
import Testing

@Suite("Collection+Reduce Tests")
struct CollectionReduceTests {
    struct TestObject: Equatable {
        let id: Int
    }

    @Test("Collection of objects get reduce into dictionary")
    func collectionOfObjectsIsReducedIntoDictionary() {
        let stubs: [TestObject] = (0 ..< 10).map { .init(id: $0) }
        let dictionary = stubs.asDictionaryOfValues(indexedBy: \.id)
        #expect(dictionary.count == 10)
        #expect(dictionary[0] == .init(id: 0))
        #expect(dictionary[9] == .init(id: 9))
    }
}

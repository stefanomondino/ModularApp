//
//  Mock.swift
//  CodableKitTests
//
//  Created by Stefano Mondino on 11/09/24.
//

import Foundation

struct Mock: ExpressibleByStringInterpolation {
    static var events: Self { "events" }
    static var vehicles: Self { "vehicles" }
    static var vehicle: Self { "vehicle" }
    static var animal: Self { "animal" }
    static var vehicleResponseWithProperties: Self { "vehicleResponseWithProperties" }
    static var watchablesWithNestedTypes: Self { "watchablesWithNestedTypes" }

    enum Error: Swift.Error {
        case dataNotFound(String)
    }

    init(stringLiteral value: String) {
        filename = value
    }

    let filename: String

    func data() throws -> Data {
        guard let url = Bundle.module.url(forResource: filename, withExtension: ".stub.json") else {
            throw Error.dataNotFound(filename)
        }
        return try Data(contentsOf: url)
    }

    func object<Value: Decodable>(of _: Value.Type = Value.self, decoder: JSONDecoder = .init()) throws -> Value {
        try decoder.decode(Value.self, from: data())
    }
}

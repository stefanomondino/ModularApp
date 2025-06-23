import Foundation

public protocol Stub {
    func read() throws -> Data
    func decode<Value: Decodable>(_ value: Value.Type, decoder: JSONDecoder) throws -> Value
}

public extension Stub {
    func decode<Value: Decodable>(_: Value.Type, decoder: JSONDecoder) throws -> Value {
        try decoder.decode(Value.self, from: read())
    }

    func decode<Value: Decodable>(_: Value.Type = Value.self) throws -> Value {
        try JSONDecoder().decode(Value.self, from: read())
    }
//    func decode<Value: Decodable>(_ value: Value.Type = Value.self, decoder: JSONDecoder) throws -> Value {
//        try decoder.decode(Value.self, from: read())
//    }
}

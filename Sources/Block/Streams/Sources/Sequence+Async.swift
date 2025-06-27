//
//  Sequence+Async.swift
//  Streams
//
//  Created by Stefano Mondino on 25/06/25.
//

//
//  Sequence+Async.swift
//  ToolKit
//
//  Created by Stefano Mondino on 25/09/24.
//

import Foundation

public extension Sequence {
    func asyncMap<T>(
        _ transform: @Sendable (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            try await values.append(transform(element))
        }

        return values
    }
}

public extension Sequence {
    func asyncCompactMap<T>(
        _ transform: @Sendable (Element) async throws -> T?
    ) async rethrows -> [T] {
        var values = [T]()

        for element in self {
            if let element = try await transform(element) {
                values.append(element)
            }
        }

        return values
    }
}

public extension Sequence {
    func asyncFlatMap<T>(
        _ transform: @Sendable (Element) async throws -> [T]
    ) async rethrows -> [T] where T: Sendable {
        var values = [T]()

        for element in self {
            values += try await transform(element)
        }

        return values
    }
}

public extension Sequence {
    func asyncForEach(
        _ operation: @Sendable (Element) async throws -> Void
    ) async rethrows {
        for element in self {
            try await operation(element)
        }
    }
}

public extension Sequence {
    func asyncReduce<Accumulator>(_ startingValue: Accumulator,
                                  _ operation: @Sendable (Accumulator, Element) async throws -> Accumulator) async rethrows -> Accumulator {
        var accumulator = startingValue
        for element in self {
            accumulator = try await operation(accumulator, element)
        }
        return accumulator
    }

    func asyncReduce<Accumulator>(into startingValue: Accumulator,
                                  _ operation: @Sendable (inout Accumulator, Element) async throws -> Void) async rethrows -> Accumulator {
        var accumulator = startingValue
        for element in self {
            try await operation(&accumulator, element)
        }
        return accumulator
    }
}

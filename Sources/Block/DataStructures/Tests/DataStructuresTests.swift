//
//  DataStructuresTests.swift
//
//
//  Created by Stefano Mondino on 05/12/21.
//

import CoreTesting
import Foundation
@testable import Streams
import Testing

extension File: @unchecked Sendable, Stub {
    public func read() throws -> Data {
        try Data(contentsOf: url)
    }
}

public typealias Stubs = Files.Sources.Block.DataStructures.Tests.Stubs

//
//  Shared.swift
//  AppSettingsTests
//
//  Created by Stefano Mondino on 24/06/25.
//

import Foundation
import Networking

typealias Stubs = Files.Sources.Features.AppSettings.Tests.Stubs

extension File: @unchecked Sendable, DataConvertible {
    public func asData() throws(NetworkingError) -> Data {
        do {
            return try Data(contentsOf: url)
        } catch {
            throw NetworkingError.dataConversionError(error)
        }
    }
}

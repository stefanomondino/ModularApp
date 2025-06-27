//
//  URLConvertible.swift
//  Networking
//
//  Created by Stefano Mondino on 25/06/25.
//
import Foundation

public protocol URLConvertible {
    var url: URL { get }
}

extension URL: URLConvertible {
    public var url: URL { self }
}

extension String: URLConvertible {
    public var url: URL {
        URL(string: self) ?? .documentsDirectory
    }
}

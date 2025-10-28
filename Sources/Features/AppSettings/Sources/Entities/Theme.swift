//
//  Theme.swift
//  AppSettings
//
//  Created by Stefano Mondino on 24/06/25.
//

import Foundation

struct Theme: Codable, Sendable, Equatable {
    let id: String
    let text: String
    let colors: [String]
}

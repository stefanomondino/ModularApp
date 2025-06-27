//
//  ThemeRepository.swift
//  AppSettings
//
//  Created by Stefano Mondino on 24/06/25.
//

import Foundation
import Networking

// extension Request.JSON {
//
//    static func queryThemes(_ query: Query) -> Request.JSON<[Theme]> {
//        Request(baseURL: "https://colormagic.app",
//                path: "/api/palette",
//                queryParameters: ["q": query.description])
//            .json()
//    }
// }

extension Request {
//    struct Query: ExpressibleByStringInterpolation, CustomStringConvertible {
//        let value: String
//        var description: String {
//            value
//        }
//
//        init(stringLiteral value: String) {
//            self.value = value
//        }
//
//        init(_ value: String) {
//            self.value = value
//        }
//    }

    static func queryThemes(_ query: String) -> Request {
        Request(baseURL: "https://colormagic.app",
                path: "/api/palette/search",
                queryParameters: ["q": query])
    }
}

protocol ThemeRepository: Sendable {
    func fetchThemes(query: String) async throws(NetworkingError) -> [Theme]
}

actor ThemeRepositoryImplementation: ThemeRepository {
    private let networking: Networking.Client

    init(networking: Networking.Client) {
        self.networking = networking
    }

    func fetchThemes(query: String) async throws(NetworkingError) -> [Theme] {
        try await networking.response(.queryThemes(query)).json()
    }
}

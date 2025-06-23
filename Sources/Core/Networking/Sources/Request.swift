import Foundation

public struct Request: Sendable, Hashable {
    public struct Path: CustomStringConvertible, Sendable, ExpressibleByStringInterpolation, ExpressibleByArrayLiteral, Hashable {
        private var value: String
        public var description: String {
            value
        }

        public init(stringLiteral value: String) {
            self.value = "/" + value.components(separatedBy: "/").filter { !$0.isEmpty }.joined(separator: "/")
        }

        public init(arrayLiteral elements: Path...) {
            value = "/" + elements.map { $0.description }
                .filter { !$0.isEmpty }
                .joined(separator: "/")
        }
    }

    public struct QueryParameters: Sendable, ExpressibleByDictionaryLiteral, Hashable {
        public typealias Key = String
        public typealias Value = String
        public var parameters: [Key: Value]
        public var isEmpty: Bool {
            parameters.isEmpty
        }

        var queryItems: [URLQueryItem] {
            parameters.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }

        public init(dictionaryLiteral elements: (String, Value)...) {
            parameters = Dictionary(uniqueKeysWithValues: elements.map { ($0.0, $0.1) })
        }

        init(_ parameters: [Key: Value]) {
            self.parameters = parameters
        }
    }

    public let baseURL: URL
    public let path: Path
    public let method: HTTPMethod
    public let httpHeaders: [String: String]
    public let queryParameters: QueryParameters
    public init(baseURL: URLConvertible,
                path: Path,
                method: HTTPMethod = .get,
                httpHeaders: [String: String] = [:],
                queryParameters: QueryParameters = [:]) {
        self.baseURL = baseURL.url
        self.path = path
        self.method = method
        self.httpHeaders = httpHeaders
        self.queryParameters = queryParameters
    }
}

public extension Request {
    enum HTTPMethod: String, Sendable, CustomStringConvertible {
        public var description: String { rawValue }

        /// `CONNECT` method.
        case connect = "CONNECT"
        /// `DELETE` method.
        case delete = "DELETE"
        /// `GET` method.
        case get = "GET"
        /// `HEAD` method.
        case head = "HEAD"
        /// `OPTIONS` method.
        case options = "OPTIONS"
        /// `PATCH` method.
        case patch = "PATCH"
        /// `POST` method.
        case post = "POST"
        /// `PUT` method.
        case put = "PUT"
        /// `TRACE` method.
        case trace = "TRACE"
    }
}

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

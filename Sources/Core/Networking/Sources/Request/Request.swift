import DataStructures
import Foundation

public struct Request: Sendable, Hashable {
    public var baseURL: URL
    public var path: Path
    public var method: HTTPMethod
    public var httpHeaders: [Header: String]
    public var queryParameters: QueryParameters
    public var body: Data?
    public var authorization: AuthorizationMode
    public init(baseURL: URLConvertible,
                path: Path,
                method: HTTPMethod = .get,
                httpHeaders: [Header: String] = [:],
                queryParameters: QueryParameters = [:],
                body: BodyParameters? = nil,
                authorization: AuthorizationMode = .none) {
        self.baseURL = baseURL.url
        self.path = path
        self.method = method
        self.httpHeaders = httpHeaders
        self.queryParameters = queryParameters
        self.authorization = authorization
        if method.allowsBody {
            self.body = body?.data
            body?.headers.forEach { key, value in
                if self.httpHeaders[key] == nil {
                    self.httpHeaders[key] = value
                }
            }
        }
    }
}

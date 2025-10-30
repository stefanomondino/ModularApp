import Foundation

public extension URL? {
    var orEmpty: URL {
        self ?? .init(fileURLWithPath: "")
    }
}

public extension URLRequest? {
    var orEmpty: URLRequest {
        self ?? .init(url: URL(string: "").orEmpty)
    }
}

public extension String {
    var url: URL {
        URL(string: trimmingCharacters(in: .whitespacesAndNewlines)).orEmpty
    }
}

public extension URL {
    var pageName: String {
        let components = URLComponents(url: self, resolvingAgainstBaseURL: false)
        let value = components?.host ?? absoluteString
        if value.starts(with: "www.") {
            return value.replacingOccurrences(of: "www.", with: "")
        }
        return value
    }
}

public extension String {
    func convertToURL() -> URL? {
        if let components = URLComponents(string: self),
           ["https", "http"].contains(components.scheme),
           let url = components.url {
            return url
        }
        let range = NSRange(location: 0, length: utf16.count)
        let pattern = "^(?!https:\\/\\/)[a-zA-Z0-9]+(\\.[a-zA-Z0-9]+)+(\\/[a-zA-Z0-9\\-._~\\/\\?#\\[\\]@!$&'()*+,;=%]*)?$"
        if let regex = try? NSRegularExpression(pattern: pattern, options: []),
           regex.firstMatch(in: "\(self)", options: [], range: range) != nil {
            return "https://\(self)".convertToURL()
        }

        return nil
    }
}

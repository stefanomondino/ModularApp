import Foundation

public extension String {
    /// Returns String unicode value of country flag for iso code

    var capitalizedFirst: String {
        guard let first = first else { return self }
        return first.uppercased() + dropFirst()
    }

    func flag() -> String {
        unicodeScalars
            .map { 127_397 + $0.value }
            .compactMap(UnicodeScalar.init)
            .map(String.init)
            .joined()
    }

    var nilIfEmpty: String? {
        isEmpty ? nil : self
    }
}

public extension CustomStringConvertible {
    var nilIfEmpty: Self? {
        description.isEmpty ? nil : self
    }
}

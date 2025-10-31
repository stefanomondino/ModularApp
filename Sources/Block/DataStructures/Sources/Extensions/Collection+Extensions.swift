import Foundation

public extension Sequence {
    func asDictionaryOfValues<Key: Hashable>(indexedBy key: KeyPath<Element, Key>) -> [Key: Element] {
        reduce(into: [:]) { accumulator, item in
            accumulator[item[keyPath: key]] = item
        }
    }

    func asDictionaryOfValues<Key: Hashable, Value>(indexedBy key: KeyPath<Element, Key>, mapper: (Element) -> Value) -> [Key: Value] {
        reduce(into: [:]) { accumulator, item in
            accumulator[item[keyPath: key]] = mapper(item)
        }
    }

    func asDictionaryOfCollections<Key: Hashable>(indexedBy key: KeyPath<Element, Key>) -> [Key: [Element]] {
        reduce(into: [:]) { accumulator, item in
            accumulator[item[keyPath: key]] = (accumulator[item[keyPath: key]] ?? []) + [item]
        }
    }

    func asDictionaryOfCollections<Key: Hashable, Value>(indexedBy key: KeyPath<Element, Key>, mapper: (Element) -> Value) -> [Key: [Value]] {
        reduce(into: [:]) { accumulator, item in
            accumulator[item[keyPath: key]] = (accumulator[item[keyPath: key]] ?? []) + [mapper(item)]
        }
    }
}

public extension Array {
    func prefixIf(_ value: Int?) -> Self {
        if let value {
            Self(prefix(value))
        } else {
            self
        }
    }
}

// public extension Publisher where Output: Collection, Output.Element: Equatable {
//    func contains(_ element: Output.Element) -> AnyPublisher<Bool, Failure> {
//        map { $0.contains(element) }
//            .eraseToAnyPublisher()
//    }
// }

public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        self?.isEmpty ?? true
    }
}

public extension Array {
    subscript(safe index: Int) -> Element? {
        get {
            indices.contains(index) ? self[index] : nil
        }
        set {
            guard let newValue, indices.contains(index) else { return }
            self[index] = newValue
        }
    }

    mutating func insert(safe newValue: Element?, at index: Int) {
        guard let newValue, indices.contains(index) else { return }
        insert(newValue, at: index)
    }

    func chunked(into size: Int) -> [[Element]] {
        stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }

    func staggered(columns: Int) -> [[Element]] {
        enumerated().reduce(into: []) { accumulator, tuple in
            let (offset, _) = tuple
            let column = offset % columns
            var currentArray = accumulator[safe: column] ?? []
            currentArray.append(self[offset])
            if accumulator[safe: column] != nil {
                accumulator[column] = currentArray
            } else {
                accumulator.append(currentArray)
            }
        }
    }
}

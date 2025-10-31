//
//  MainActorProvider.swift
//  DependencyContainer
//
//  Created by Stefano Mondino on 10/06/25.
//

public protocol MainActorProvider: AnyObject, Sendable {
    associatedtype Key: Hashable, Sendable
    @MainActor var storage: Storage<Key> { get }
}

@MainActor
public final class Storage<Key: Hashable & Sendable> {
    private var storage: [Key: () -> Any] = [:]
    public init(_: Key.Type = Key.self) {}
    fileprivate subscript(key: Key) -> (() -> Any)? {
        get { storage[key] }
        set { storage[key] = newValue }
    }
}

public typealias MainActorTypeStorage = Storage<ObjectIdentifier>

public extension MainActorProvider {
    @discardableResult
    @MainActor func register<Value: Sendable>(for key: Key,
                                              type _: Value.Type = Value.self,
                                              callback: @Sendable @escaping @MainActor () -> Value) -> Self {
        storage[key] = { callback() }
        return self
    }

    @MainActor func resolve<Value: Sendable>(_ key: Key,
                                             type _: Value.Type = Value.self,
                                             default defaultValue: Value) -> Value {
        print("\(Value.self) for \(key)")
        guard let value = (storage[key]?() as? Value) else {
            register(for: key) { defaultValue }
            return defaultValue
        }
        return value
    }

    @MainActor func resolve<Value: Sendable>(_ key: Key) -> Value? {
        storage[key]?() as? Value
    }
}

public extension MainActorProvider where Key == ObjectIdentifier {
    @discardableResult
    @MainActor func register<Value: Sendable>(for key: Value.Type = Value.self, callback: @Sendable @escaping @MainActor () -> Value) -> Self {
        register(for: ObjectIdentifier(key), callback: callback)
        return self
    }

    @MainActor func resolve<Value: Sendable>(_ key: Value.Type = Value.self, default defaultValue: Value) -> Value {
        resolve(ObjectIdentifier(key), default: defaultValue)
    }

    @MainActor func resolve<Value: Sendable>(_ key: Value.Type = Value.self) -> Value? {
        resolve(ObjectIdentifier(key))
    }
}

@propertyWrapper @MainActor public struct Provided<Value: Sendable> {
    private let defaultValue: Value
    public init(defaultValue: Value) {
        self.defaultValue = defaultValue
    }

    public init() where Value: ExpressibleByNilLiteral {
        defaultValue = nil
    }

    @available(*, unavailable,
               message: "This property wrapper can only be applied to classes")
    public var wrappedValue: Value {
        get { fatalError() }
        // swiftlint:disable unused_setter_value
        set { fatalError() }
    }

    public static subscript<Container: MainActorProvider>(_enclosingInstance instance: Container,
                                                          wrapped _: ReferenceWritableKeyPath<Container, Value>,
                                                          storage storageKeyPath: ReferenceWritableKeyPath<Container, Self>) -> Value where Container.Key == ObjectIdentifier {
        get {
            if let value = instance.resolve(Value.self) {
                return value
            }
            return instance[keyPath: storageKeyPath].defaultValue
        }
        set {}
    }
}

import DependencyContainer
import Logger
import Streams
import UIKit

public typealias RouteContainer = Router.Container

@MainActor
public final class Router {
    /**
            An object containing all the `Route` underlying implementations associated to a `RouteDefinition` type.

     This is slightly different compared to regular `ObjectContainer` and similar to
     `DependencyContainer` core framework because it's used to register closures returning `Route`
     and associate them to `RouteDefinition.Type` identifiers.
     */
    public actor Container {
        fileprivate let container: ObjectContainer

        /// Initialize the custom `Container` object using a dependency container.
        /// - Parameters:
        ///     - container: an `ObjectContainer` use to register closures associated to object Types.
        public init(_ container: ObjectContainer = .init()) {
            self.container = container
        }

        /// Registers a specific association between a concrete `RouteDefinition` and a concrete `Route`
        /// - Parameters:
        ///     - definitionType: the type of the `RouteDefinition` object getting registered
        ///     - closure: a closure that will associate a concrete definition of given type to a concrete `Route`
        public func register<Definition: RouteDefinition>(for definitionType: Definition.Type,
                                                          closure: @Sendable @escaping @MainActor (Definition) async -> Route) async {
            await container.register(for: ObjectIdentifier(definitionType),
                                     handler: { closure })
        }
    }

    let routes: Signal<RouteDefinition> = .init()
    let container: Container

    public init(container: Container, name: String = "Auto-created Router") {
        self.container = container
        Task {
            for await route in definitionStream {
                print("Router \(name) emitted route \(route)")
            }
        }
    }

    var definitionStream: ShareableAsyncStream<RouteDefinition> {
        routes.asAsyncStream()
    }

    public func send(_ route: RouteDefinition) {
        routes.send(route)
    }

    public func send(_ id: Identifier) {
        send(id.definition)
    }

    @MainActor
    func resolve<Definition: RouteDefinition>(_ definition: Definition) async -> Route? {
        guard let handler: @Sendable @MainActor (Definition) async -> Route = await container.container.resolve(
            ObjectIdentifier(Definition.self),
            type: (@Sendable @MainActor (Definition) async -> Route).self
        ) else {
            Logger.log("Route not found: \(definition)", level: .warning, tag: .routes)
            return nil
        }
        return await handler(definition)
    }
}

public extension Router {
    /// A support object used to easily retrieve route definitions in `Router.send` function.
    ///
    /// > Behavior is automatically extended by a Sourcery template, with a 1to1 mapping between every `Router.RouteDefinition`
    /// static func or variable and same function on `Identifier` object

    struct Identifier: Sendable {
        let definition: RouteDefinition
        public init(_ definition: RouteDefinition) {
            self.definition = definition
        }
    }
}

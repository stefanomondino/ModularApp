import DependencyContainer
import Foundation
import UIKit

public protocol AppContainer: DependencyContainer {
    var services: [String: Service] { get async }
    @MainActor func setup() async
    init()
}

open class AppDelegate<Container: AppContainer>: UIResponder, UIApplicationDelegate {
    private var services: [String: Service] = [:]
    public let container: Container = .init()
    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?

    public func register(service: Service) {
        services[service.serviceIdentifier.stringValue] = service
    }

    public func register(services: [Service]) {
        for item in services {
            register(service: item)
        }
    }

    @MainActor func startAfterContainerSetup() async {
        let launchOptions = launchOptions
        await container.setup()
        await register(services: container.services.map { $0.value })
        _ = apply { $0.didFinishLaunching(with: launchOptions) }.allSatisfy { $0 }
        self.launchOptions = nil
    }

    public func unregisterService(with identifier: any ServiceIdentifier) {
        services[identifier.stringValue] = nil
    }

    @discardableResult
    private func apply<Result>(closure: @escaping (Service) -> Result) -> [Result] {
        services.map {
            closure($0.value)
        }
    }

    open func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        self.launchOptions = launchOptions
        Task {
            await self.startAfterContainerSetup()
        }
        return true
    }

    public func applicationDidReceiveMemoryWarning(_: UIApplication) {
        apply { $0.didReceiveMemoryWarning() }
    }

    public func applicationDidBecomeActive(_: UIApplication) {
        apply { $0.didBecomeActive() }
    }

    public func applicationWillResignActive(_: UIApplication) {
        apply { $0.willResignActive() }
    }

    public func applicationDidEnterBackground(_: UIApplication) {
        apply { $0.didEnterBackground() }
    }

    public func applicationWillEnterForeground(_: UIApplication) {
        apply { $0.willEnterForeground() }
    }

//    public func application(_: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//        apply { $0.open(url: url, options: options) }.allSatisfy { $0 }
//    }

    public func application(_: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        apply { $0.willContinueUserActivity(with: userActivityType) }.allSatisfy { $0 }
    }

    public func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        apply { $0.continue(userActivity: userActivity, restorationHandler: restorationHandler) }
            .allSatisfy { $0 }
    }

    public func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        apply { $0.didRegisterForRemoteNotifications(with: deviceToken) }
    }

    public func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        apply { $0.didFailToRegisterForRemoteNotifications(with: error) }
    }

    public func application(_: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        apply { $0.didReceiveRemoteNotification(userInfo: userInfo, fetchCompletionHandler: completionHandler) }
    }
}

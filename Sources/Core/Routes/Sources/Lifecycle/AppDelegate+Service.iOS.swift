import DependencyContainer
import Foundation
import UIKit

@MainActor
public protocol AppContainer: DependencyContainer {
//    var services: [String: Service] { get async }
    var serviceManager: ServiceManager { get }
    @MainActor func setup() async
    init()
}

@Observable
public final class ServiceManager: Service {
    public init() {}
    private var services: [String: Service] = [:]
    public func register(_ service: Service) {
        services[service.serviceIdentifier.stringValue] = service
    }
    
    public func register(_ services: [Service]) {
        for item in services {
            register(item)
        }
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
    
    public func didFinishLaunching(with options: LaunchDelegateOptions?) -> Bool {
        apply { $0.didFinishLaunching(with: options) }.allSatisfy { $0 }
    }
    
    public func didReceiveMemoryWarning() {
        apply { $0.didReceiveMemoryWarning() }
    }
    public func didBecomeActive() {
        apply { $0.didBecomeActive() }
    }
    public func willResignActive() {
        apply { $0.willResignActive() }
    }
    public func didEnterBackground() {
        apply { $0.didEnterBackground() }
    }
    public func willEnterForeground() {
        apply { $0.willEnterForeground() }
    }
    public func open(url: URL, options: OpenDelegateOptions) -> Bool {
        apply { $0.open(url: url, options: options) }.allSatisfy { $0 }
    }
    public func open(url: URL, options: OpenSceneOptions) -> Bool {
        apply { $0.open(url: url, options: options) }.allSatisfy { $0 }
    }
    public func willContinueUserActivity(with type: String) -> Bool {
        apply { $0.willContinueUserActivity(with: type) }.allSatisfy { $0 }
    }
    public func `continue`(userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool {
        apply { $0.continue(userActivity: userActivity, restorationHandler: restorationHandler) }.allSatisfy { $0 }
    }
    public func didRegisterForRemoteNotifications(with deviceToken: Data) {
        apply { $0.didRegisterForRemoteNotifications(with: deviceToken) }
    }
    public func didFailToRegisterForRemoteNotifications(with error: any Error) {
        apply { $0.didFailToRegisterForRemoteNotifications(with: error) }
    }
    
    public func didReceiveRemoteNotification(userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        apply { $0.didReceiveRemoteNotification(userInfo: userInfo, fetchCompletionHandler: completionHandler) }
    }
}

open class AppDelegate<Container: AppContainer>: UIResponder, UIApplicationDelegate {
    
    public let container: Container = .init()
    private var launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    private var serviceManager: ServiceManager { container.serviceManager }
    @MainActor public func startAfterContainerSetup() async {
        let launchOptions = launchOptions
        await container.setup()
        _ = serviceManager.didFinishLaunching(with: launchOptions)
        self.launchOptions = nil
    }

    open func application(_: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        self.launchOptions = launchOptions
        Task {
            await self.startAfterContainerSetup()
        }
        return true
    }

    public func applicationDidReceiveMemoryWarning(_: UIApplication) {
        serviceManager.didReceiveMemoryWarning()
    }

    public func applicationDidBecomeActive(_: UIApplication) {
        serviceManager.didBecomeActive()
    }

    public func applicationWillResignActive(_: UIApplication) {
        serviceManager.willResignActive()
    }

    public func applicationDidEnterBackground(_: UIApplication) {
        serviceManager.didEnterBackground()
    }

    public func applicationWillEnterForeground(_: UIApplication) {
        serviceManager.willEnterForeground()
    }

    public func application(_: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        serviceManager.open(url: url, options: options)
    }

    public func application(_: UIApplication, willContinueUserActivityWithType userActivityType: String) -> Bool {
        serviceManager.willContinueUserActivity(with: userActivityType)
    }

    public func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        serviceManager.continue(userActivity: userActivity, restorationHandler: restorationHandler)
    }

    public func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        serviceManager.didRegisterForRemoteNotifications(with: deviceToken)
    }

    public func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        serviceManager.didFailToRegisterForRemoteNotifications(with: error)
    }

    public func application(_: UIApplication,
                            didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        serviceManager.didReceiveRemoteNotification(userInfo: userInfo, fetchCompletionHandler: completionHandler)
    }
}

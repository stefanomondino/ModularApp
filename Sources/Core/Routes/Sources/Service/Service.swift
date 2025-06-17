//
//  Service.swift
//  CorePlatform
//
//  Created by Stefano Mondino on 02/06/21.
//

import DataStructures
import Foundation

#if os(iOS) || os(tvOS)
    import UIKit

    public typealias LaunchDelegateOptions = [UIApplication.LaunchOptionsKey: Any]
    public typealias LaunchSceneOptions = UIScene.ConnectionOptions
    public typealias OpenSceneOptions = UIScene.OpenURLOptions
    public typealias OpenDelegateOptions = [UIApplication.OpenURLOptionsKey: Any]
#else
    public typealias LaunchDelegateOptions = [AnyHashable: Any]
    public typealias OpenDelegateOptions = [String: Any]
    public typealias LaunchSceneOptions = NSScene.ConnectionOptions
    public typealias OpenSceneOptions = [NSApplication.OpenURLOptionsKey: Any]
#endif

public protocol ServiceIdentifier: UniqueIdentifier, Hashable, Equatable {}

extension ObjectIdentifier: @retroactive UniqueIdentifier {}
extension ObjectIdentifier: ServiceIdentifier {
    public var stringValue: String {
        "\(self)"
    }
}

/// A Service is an object strictly tied to the application lifecycle
@MainActor public protocol Service: AnyObject, Sendable {
    var serviceIdentifier: any ServiceIdentifier { get }
    func didFinishLaunching(with options: LaunchDelegateOptions?) -> Bool
    func willConnectToScene(with options: LaunchSceneOptions)
    func didReceiveMemoryWarning()
    func didRegisterForRemoteNotifications(with deviceToken: Data)
    func didReceiveRemoteNotification(userInfo: [AnyHashable: Any],
                                      fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void)
    func didFailToRegisterForRemoteNotifications(with error: Error)
    func didBecomeActive()
    func willResignActive()
    func willEnterForeground()
    func didEnterBackground()
    func open(url: URL, options: OpenDelegateOptions) -> Bool
    func open(url: URL, options: OpenSceneOptions) -> Bool
    func willContinueUserActivity(with type: String) -> Bool
    func `continue`(userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool
}

public extension Service {
    var serviceIdentifier: any ServiceIdentifier { ObjectIdentifier(self) }
    func didFinishLaunching(with _: LaunchDelegateOptions?) -> Bool { true }
    func willConnectToScene(with _: LaunchSceneOptions) {}
    func didReceiveMemoryWarning() {}
    func didRegisterForRemoteNotifications(with _: Data) {}
    func didFailToRegisterForRemoteNotifications(with _: Error) {}
    func didBecomeActive() {}
    func willEnterForeground() {}
    func didEnterBackground() {}
    func willResignActive() {}
    func willContinueUserActivity(with _: String) -> Bool { true }
    func open(url _: URL, options _: OpenDelegateOptions) -> Bool { true }
    func open(url _: URL, options _: OpenSceneOptions) -> Bool { true }
    func `continue`(userActivity _: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool { true }
    func didReceiveRemoteNotification(userInfo _: [AnyHashable: Any],
                                      fetchCompletionHandler _: @escaping (UIBackgroundFetchResult) -> Void) {}
}

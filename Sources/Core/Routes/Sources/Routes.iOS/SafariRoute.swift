//
//  SafariRoute.swift
//  App
//
//  Created by Stefano Mondino on 11/12/2019.
//  Copyright © 2019 Deltatre. All rights reserved.
//

import Foundation
import SafariServices

public struct SafariRoute: UIKitRoute {
    public let createViewController: @MainActor @Sendable () async -> UIViewController?
    public let url: URL
    public let external: Bool
    public var presentationMode: UIKitPresentationMode { .present }
    public init(url: URL, external: Bool = false) {
        createViewController = {
            if external {
                await UIApplication.shared.open(url)
                return nil
            }
            return SFSafariViewController(url: url)
        }
        self.url = url
        self.external = external
    }

    @MainActor public func execute(from scene: (some UIViewController)?) async {
        guard let viewController = await createViewController(),
              let presentationContext: UIViewController = scene
        else { return }

        presentationContext.present(viewController,
                                    animated: true,
                                    completion: {})
    }
}

public struct WebRouteDefinition: RouteDefinition, Equatable {
    public let identifier: String = UUID().uuidString
    public let url: URL
    public let external: Bool
    public init(_ string: String, external: Bool = false) {
        url = URL(string: string) ?? .homeDirectory
        self.external = external
    }

    public init(_ url: URL, external: Bool = false) {
        self.url = url
        self.external = external
    }
}

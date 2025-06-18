//
//  Router+UIViewControllerRepresentable.iOS.swift
//  Routes
//
//  Created by Stefano Mondino on 17/06/25.
//

import Foundation
import SwiftUI
import UIKit

struct ViewControllerWrapper: UIViewControllerRepresentable {
    let viewController: UIViewController
    func makeUIViewController(context _: Context) -> UIViewController {
        viewController
    }

    func updateUIViewController(_: UIViewController, context _: Context) {}
}

struct UIViewControllerNavigationModifier<CustomRoute: SwiftUIRoute & RouteDefinition>: ViewModifier {
    @Environment(\.router) var router
    func body(content: Content) -> some View {
        content.task {
            if let router {
                for await definition in await router.definitionStream {
                    if let definition = await router.resolve(definition) as? UIKitRoute,
                       let viewController = await definition.createViewController() {
                        await router.send(CustomRoute(identifier: UUID().uuidString) {
                            ViewControllerWrapper(viewController: viewController)
                        })
                    }
                }
            }
        }
    }
}

extension View {
    func uiKitNavigation() -> some View {
        modifier(UIViewControllerNavigationModifier<SwiftUINavigationRoute>())
    }

    func uiKitModal() -> some View {
        modifier(UIViewControllerNavigationModifier<SwiftUIModalRoute>())
    }
}

//
//  UIKitView.swift
//  CorePhone
//
//  Created by Stefano Mondino on 18/05/23.
//
#if os(iOS) || os(tvOS)
    import DataStructures
    import Foundation
    import Logger
    import SwiftUI
    import UIKit

    public struct UIViewWrapper<WrappedView: UIView, WrappedContext>: UIViewRepresentable {
        let viewInitialization: () -> WrappedView
        let viewUpdate: (WrappedView) -> Void
        let forceIntrinsicConstraints: Bool
        @State var context: WrappedContext?

        public init(forceIntrinsicConstraints: Bool = true,
                    viewInitialization: @escaping () -> WrappedView,
                    viewUpdate: @escaping (WrappedView) -> Void = { _ in },
                    context: WrappedContext? = nil) {
            self.viewInitialization = viewInitialization
            self.forceIntrinsicConstraints = forceIntrinsicConstraints
            self.viewUpdate = viewUpdate
            self.context = context
        }

        public func makeUIView(context _: Context) -> WrappedView {
            let view = viewInitialization()
            if forceIntrinsicConstraints {
                view.translatesAutoresizingMaskIntoConstraints = false
                view.setContentHuggingPriority(.defaultHigh - 1, for: .horizontal)
                view.setContentHuggingPriority(.defaultHigh - 1, for: .vertical)
                view.setContentCompressionResistancePriority(.required, for: .horizontal)
                view.setContentCompressionResistancePriority(.required, for: .vertical)
            }
            return view
        }

        public func updateUIView(_ view: WrappedView, context _: Context) {
            viewUpdate(view)
        }
    }

    // swiftlint:disable generic_type_name
    public struct UIViewControllerWrapper<WrappedViewController: UIViewController>: UIViewControllerRepresentable {
        public func makeUIViewController(context _: Context) -> WrappedViewController {
            let controller = viewControllerInitialization()
            return controller
        }

        public func updateUIViewController(_ uiViewController: WrappedViewController, context _: Context) {
            viewControllerUpdate(uiViewController)
        }

        let viewControllerInitialization: () -> WrappedViewController
        let viewControllerUpdate: (WrappedViewController) -> Void
        public init(viewControllerInitialization: @escaping () -> WrappedViewController,
                    viewControllerUpdate: @escaping (WrappedViewController) -> Void = { _ in }) {
            self.viewControllerInitialization = viewControllerInitialization
            self.viewControllerUpdate = viewControllerUpdate
        }

        public init<Wrapped: UIViewController>(viewControllerInitialization: @escaping () async -> Wrapped,
                                               viewControllerUpdate: @escaping (Wrapped) -> Void = { _ in })
            where WrappedViewController == AsyncViewController<Wrapped> {
            self.viewControllerInitialization = { AsyncViewController(disableAutolayout: true) { await viewControllerInitialization() } }
            self.viewControllerUpdate = {
                if let wrapped = $0.viewController {
                    viewControllerUpdate(wrapped)
                }
            }
        }

        public func sizeThatFits(_ proposal: ProposedViewSize, uiViewController: WrappedViewController, context _: Context) -> CGSize? {
            let size = uiViewController.view
                .systemLayoutSizeFitting(.init(width: proposal.width ?? 0,
                                               height: UIView.noIntrinsicMetric),
                                         withHorizontalFittingPriority: .required,
                                         verticalFittingPriority: .fittingSizeLevel)
            return size.area > 0 ? size : nil
        }
    }

    public extension UIViewController {
        var swiftUI: some View {
            UIViewControllerWrapper(viewControllerInitialization: { self })
        }
    }

    public extension UIViewWrapper where WrappedContext == Void {
        init(forceIntrinsicConstraints: Bool = true,
             viewInitialization: @escaping () -> WrappedView,
             viewUpdate: @escaping (WrappedView) -> Void = { _ in }) {
            self.viewInitialization = viewInitialization
            self.forceIntrinsicConstraints = forceIntrinsicConstraints
            self.viewUpdate = viewUpdate
            context = nil
        }
    }
#endif

import UIKit

#if os(iOS) || os(tvOS)
    @MainActor
    protocol WithAsyncViewController {
        var asyncViewController: UIViewController? { get }
    }

    /// A wrapper around UIViewController with async initialization
    public final class AsyncViewController<WrappedViewController: UIViewController>: UIViewController, WithAsyncViewController {
        let callback: () async -> WrappedViewController?
        weak var viewController: WrappedViewController?
        public var asyncViewController: UIViewController? { viewController }
        var disableAutolayout: Bool = false
        public init(disableAutolayout: Bool = false, _ callback: @escaping () async -> WrappedViewController?) {
            self.callback = callback
            self.disableAutolayout = disableAutolayout
            super.init(nibName: nil, bundle: nil)
        }

        @available(*, unavailable)
        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override public func viewDidLoad() {
            super.viewDidLoad()

            Task { @MainActor in
                if let viewController = await self.callback() {
                    self.viewController = viewController
                    self.addChild(viewController)

                    if disableAutolayout {
                        view.translatesAutoresizingMaskIntoConstraints = false
                        self.view.addSubview(viewController.view)
                        NSLayoutConstraint.activate([viewController.view.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                                                     viewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                                                     viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                                                     viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0)])
                        self.preferredContentSize = viewController.view.systemLayoutSizeFitting(.init(width: view.frame.size.width,
                                                                                                      height: UIView.noIntrinsicMetric),
                                                                                                withHorizontalFittingPriority: .required,
                                                                                                verticalFittingPriority: .fittingSizeLevel)
                        viewController.didMove(toParent: self)
                    } else {
                        self.view.wrap { viewController.view }
                    }
                }
            }
        }
    }
#endif

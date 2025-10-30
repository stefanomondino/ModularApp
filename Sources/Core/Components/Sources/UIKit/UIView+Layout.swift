#if os(iOS) || os(tvOS)

    import Foundation
    import UIKit

    public enum UIVerticalAlignment {
        case top
        case bottom
        case center
        case fill
    }

    public enum UIHorizontalAlignment {
        case left
        case right
        case center
        case fill
    }

    public extension UILayoutPriority {
        static var medium: UILayoutPriority {
            UILayoutPriority.defaultHigh - UILayoutPriority.defaultLow.rawValue
        }
    }

    @resultBuilder
    public enum UIViewBuilder {
        static func buildBlock() -> [UIView?] { [] }

        public static func buildBlock(_ subviews: UIView...) -> [UIView] {
            subviews
        }

        public static func buildBlock(_ subviews: UIView?...) -> [UIView?] {
            subviews
        }
    }

    public extension UIView {
        @discardableResult
        func withHorizontalHugging(to value: UILayoutPriority) -> Self {
            setContentHuggingPriority(value, for: .horizontal)
            return self
        }

        @discardableResult
        func withVerticalHugging(to value: UILayoutPriority) -> Self {
            setContentHuggingPriority(value, for: .vertical)
            return self
        }

        @discardableResult
        func withHorizontalCompression(to value: UILayoutPriority) -> Self {
            setContentCompressionResistancePriority(value, for: .horizontal)
            return self
        }

        @discardableResult
        func withVerticalCompression(to value: UILayoutPriority) -> Self {
            setContentCompressionResistancePriority(value, for: .vertical)
            return self
        }

        @discardableResult
        func wrap(insets: UIEdgeInsets = .zero,
                  guides: Guide = .init(),
                  view: () -> UIView?) -> Self {
            if let view = view() {
                layoutZ(view,
                        insets: insets,
                        guides: guides)
            }
            return self
        }

        @discardableResult
        func stackZ(insets: UIEdgeInsets = .zero,
                    guides: Guide = .init(),
                    @UIViewBuilder _ view: () -> [UIView?]) -> Self {
            layoutZ(view().compactMap { $0 },
                    insets: insets,
                    guides: guides)

            return self
        }

        @discardableResult
        func stackHorizontally(spacing: CGFloat = 0,
                               alignment: UIVerticalAlignment = .fill,
                               insets: UIEdgeInsets = .zero,
                               guides: Guide = .init(),
                               @UIViewBuilder _ content: () -> [UIView?]) -> Self {
            layoutHorizontally(content().compactMap { $0 },
                               spacing: spacing,
                               alignment: alignment,
                               insets: insets,
                               guides: guides)
            return self
        }

        @discardableResult
        func stackVertically(spacing: CGFloat = 0,
                             alignment: UIHorizontalAlignment = .fill,
                             insets: UIEdgeInsets = .zero,
                             guides: Guide = .init(),
                             @UIViewBuilder _ content: () -> [UIView?]) -> Self {
            layoutVertically(content().compactMap { $0 },
                             spacing: spacing,
                             alignment: alignment,
                             insets: insets,
                             guides: guides)
            return self
        }

        @discardableResult
        func constraining(width: CGFloat? = nil,
                          height: CGFloat? = nil) -> Self {
            if let width {
                addConstraint(widthAnchor.constraint(equalToConstant: width))
            }
            if let height {
                addConstraint(heightAnchor.constraint(equalToConstant: height))
            }
            return self
        }
    }

    @MainActor
    public struct Guide {
        public typealias Vertical = KeyPath<UIView, NSLayoutYAxisAnchor>
        public typealias Horizontal = KeyPath<UIView, NSLayoutXAxisAnchor>
        let top: Vertical
        let bottom: Vertical
        let left: Horizontal
        let right: Horizontal
        public init(top: Vertical = \.topAnchor,
                    bottom: Vertical = \.bottomAnchor,
                    left: Horizontal = \.leadingAnchor,
                    right: Horizontal = \.trailingAnchor) {
            self.top = top
            self.bottom = bottom
            self.left = left
            self.right = right
        }
    }

    public extension UIView {
        func isContained<View: UIView>(in type: View.Type) -> Bool {
            self is View || (superview?.isContained(in: type) ?? false)
        }

        func addSubviews(_ views: [UIView]) {
            views.forEach { addSubview($0) }
        }

        func addAndPinToSuperview(view: UIView,
                                  insets: UIEdgeInsets = .zero,
                                  guides: Guide = .init()) {
            view.translatesAutoresizingMaskIntoConstraints = false
            addSubview(view)
            addConstraints([view.topAnchor.constraint(equalTo: self[keyPath: guides.top], constant: insets.top),
                            view.bottomAnchor.constraint(equalTo: self[keyPath: guides.bottom], constant: -insets.bottom),
                            view.leadingAnchor.constraint(equalTo: self[keyPath: guides.left], constant: insets.left),
                            view.trailingAnchor.constraint(equalTo: self[keyPath: guides.right], constant: -insets.right)])
        }

        func layoutZ(_ subview: UIView,
                     spacing _: CGFloat = 0,
                     insets: UIEdgeInsets = .zero,
                     guides: Guide = .init()) {
            layoutZ([subview],
                    insets: insets,
                    guides: guides)
        }

        func layoutZ(_ subviews: [UIView],
                     spacing _: CGFloat = 0,
                     insets: UIEdgeInsets = .zero,
                     guides: Guide = .init()) {
            self.subviews.forEach { $0.removeFromSuperview() }
            for view in subviews {
                view.translatesAutoresizingMaskIntoConstraints = false
                addSubview(view)

                addConstraints([view.topAnchor.constraint(equalTo: self[keyPath: guides.top], constant: insets.top),
                                view.bottomAnchor.constraint(equalTo: self[keyPath: guides.bottom], constant: -insets.bottom),
                                view.leadingAnchor.constraint(equalTo: self[keyPath: guides.left], constant: insets.left),
                                view.trailingAnchor.constraint(equalTo: self[keyPath: guides.right], constant: -insets.right)])
            }
        }

        // swiftlint:disable function_body_length
        func layoutHorizontally(_ subviews: [UIView],
                                spacing: CGFloat = 0,
                                alignment: UIVerticalAlignment = .fill,
                                insets: UIEdgeInsets = .zero,
                                guides: Guide = .init()) {
            self.subviews.forEach { $0.removeFromSuperview() }
            let last: UIView? = subviews.reduce(nil) { last, current in
                current.translatesAutoresizingMaskIntoConstraints = false
                addSubview(current)
                var constraints: [NSLayoutConstraint] = switch alignment {
                case .fill:
                    [current.topAnchor.constraint(equalTo: self[keyPath: guides.top], constant: insets.top),
                     current.bottomAnchor.constraint(equalTo: self[keyPath: guides.bottom], constant: -insets.bottom)]
                case .top:
                    [current.topAnchor.constraint(equalTo: self[keyPath: guides.top], constant: insets.top),
                     current.bottomAnchor.constraint(lessThanOrEqualTo: self[keyPath: guides.bottom], constant: -insets.bottom)]
                case .bottom:
                    [current.topAnchor.constraint(greaterThanOrEqualTo: self[keyPath: guides.top], constant: insets.top),
                     current.bottomAnchor.constraint(equalTo: self[keyPath: guides.bottom], constant: -insets.bottom)]
                case .center:
                    [current.topAnchor.constraint(greaterThanOrEqualTo: self[keyPath: guides.top], constant: insets.top),
                     current.bottomAnchor.constraint(lessThanOrEqualTo: self[keyPath: guides.bottom], constant: -insets.bottom),
                     current.centerYAnchor.constraint(equalTo: self.centerYAnchor)]
                }
                if let last {
                    constraints.append(current.leadingAnchor.constraint(equalTo: last.trailingAnchor, constant: spacing))
                } else {
                    constraints.append(current.leadingAnchor.constraint(equalTo: self[keyPath: guides.left], constant: insets.left))
                }
                addConstraints(constraints)
                return current
            }
            if let last {
                addConstraint(last.trailingAnchor.constraint(equalTo: self[keyPath: guides.right],
                                                             constant: -insets.right))
            }
        }

        func layoutVertically(_ subviews: [UIView],
                              spacing: CGFloat = 0,
                              alignment: UIHorizontalAlignment = .fill,
                              insets: UIEdgeInsets = .zero,
                              guides: Guide = .init()) {
            self.subviews.forEach { $0.removeFromSuperview() }
            let last: UIView? = subviews.reduce(nil) { last, current in
                current.translatesAutoresizingMaskIntoConstraints = false
                addSubview(current)

                var constraints: [NSLayoutConstraint] = switch alignment {
                case .left:
                    [current.leadingAnchor.constraint(equalTo: self[keyPath: guides.left], constant: insets.left),
                     current.trailingAnchor.constraint(lessThanOrEqualTo: self[keyPath: guides.right], constant: -insets.right)]
                case .right:
                    [current.leadingAnchor.constraint(greaterThanOrEqualTo: self[keyPath: guides.left], constant: insets.left),
                     current.trailingAnchor.constraint(equalTo: self[keyPath: guides.right], constant: -insets.right)]
                case .center:
                    [current.leadingAnchor.constraint(greaterThanOrEqualTo: self[keyPath: guides.left], constant: insets.left),
                     current.trailingAnchor.constraint(lessThanOrEqualTo: self[keyPath: guides.right], constant: -insets.right),
                     current.centerXAnchor.constraint(equalTo: self.centerXAnchor)]
                case .fill:
                    [current.leadingAnchor.constraint(equalTo: self[keyPath: guides.left], constant: insets.left),
                     current.trailingAnchor.constraint(equalTo: self[keyPath: guides.right], constant: -insets.right)]
                }

                if let last {
                    constraints.append(current.topAnchor.constraint(equalTo: last.bottomAnchor, constant: spacing))
                } else {
                    constraints.append(current.topAnchor.constraint(equalTo: self[keyPath: guides.top], constant: insets.top))
                }

                addConstraints(constraints)
                return current
            }
            if let last {
                addConstraint(last.bottomAnchor.constraint(equalTo: self[keyPath: guides.bottom], constant: -insets.bottom))
            }
        }
    }
#endif

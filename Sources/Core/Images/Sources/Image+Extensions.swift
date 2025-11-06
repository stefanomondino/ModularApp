#if os(iOS) || os(tvOS)
    import Foundation
    import UIKit

    public extension UIImage {
        static func shape(with bezier: UIBezierPath,
                          strokeColor: UIColor = .clear,
                          fillColor: UIColor = .clear,
                          lineWidth: CGFloat = 0) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(bezier.bounds.insetBy(dx: -lineWidth / 2.0,
                                                                         dy: -lineWidth / 2.0).size, false, 0)
            bezier.apply(CGAffineTransform(translationX: lineWidth / 2.0, y: lineWidth / 2.0))
            fillColor.setFill()

            bezier.fill()
            if lineWidth > 0 {
                strokeColor.setStroke()
                bezier.stroke()
            }
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image ?? UIImage()
        }

        static func rectangle(size: CGSize,
                              strokeColor: UIColor = .clear,
                              fillColor: UIColor = .clear,
                              lineWidth: CGFloat = 0,
                              cornerRadius: CGFloat = 0) -> UIImage {
            let rect = CGRect(origin: .zero, size: size)
            let bezier = if cornerRadius > 0 {
                UIBezierPath(roundedRect: rect, cornerRadius: cornerRadius)
            } else {
                UIBezierPath(rect: rect)
            }
            return shape(with: bezier,
                         strokeColor: strokeColor,
                         fillColor: fillColor,
                         lineWidth: lineWidth)
        }

        static func circle(radius: CGFloat,
                           strokeColor: UIColor = .clear,
                           fillColor: UIColor = .clear,
                           lineWidth: CGFloat = 0) -> UIImage {
            let bezier = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: radius * 2, height: radius * 2))
            return shape(with: bezier,
                         strokeColor: strokeColor,
                         fillColor: fillColor,
                         lineWidth: lineWidth)
        }

        static func oval(rect: CGRect,
                         strokeColor: UIColor = .clear,
                         fillColor: UIColor = .clear,
                         lineWidth: CGFloat = 0) -> UIImage {
            let bezier = UIBezierPath(ovalIn: rect)
            return shape(with: bezier,
                         strokeColor: strokeColor,
                         fillColor: fillColor,
                         lineWidth: lineWidth)
        }

        static func background(color: UIColor = .clear) -> UIImage {
            let width: CGFloat = 1
            let bezier = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width * 2, height: width * 2))
            return shape(with: bezier, fillColor: color)
                .resizableImage(withCapInsets: UIEdgeInsets(top: width, left: width, bottom: width, right: width),
                                resizingMode: .stretch)
        }

        func masked(by shape: UIBezierPath) -> UIImage {
            guard (size.width * size.height) > 0 else { return self }
            let rect = shape.bounds
            UIGraphicsBeginImageContextWithOptions(rect.size, false, scale)
            let point = CGPoint(x: (rect.size.width - size.width) / 2, y: (rect.size.height - size.height) / 2)
            shape.addClip()
            draw(at: point)
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }

        var fillRect: CGRect {
            let dimension = min(size.width, size.height)
            return CGRect(x: 0, y: 0, width: dimension, height: dimension)
        }

        var fitRect: CGRect {
            let dimension = max(size.width, size.height)
            return CGRect(x: 0, y: 0, width: dimension, height: dimension)
        }

        func circled() -> UIImage {
            masked(by: UIBezierPath(ovalIn: fillRect))
        }

        func squared(with cornerRadius: CGFloat = 0.0) -> UIImage {
            masked(by: UIBezierPath(roundedRect: fillRect, cornerRadius: cornerRadius))
        }

        func tinted(with color: UIColor) -> UIImage {
            var image = withRenderingMode(.alwaysTemplate)
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            color.set()
            image.draw(in: CGRect(origin: .zero, size: size))
            image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }

        func overlaying(_ image: UIImage, at point: CGPoint? = nil) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, scale)
            draw(at: .zero)
            let point = point ?? CGPoint(x: (size.width - image.size.width) / 2,
                                         y: (size.height - image.size.height) / 2)
            image.draw(at: point)
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }

        func insetted(by insets: UIEdgeInsets) -> UIImage {
            let baseRect = CGRect(origin: CGPoint(x: insets.left, y: insets.top),
                                  size: CGSize(width: size.width + insets.left + insets.right,
                                               height: size.height + insets.top + insets.bottom))

            UIGraphicsBeginImageContextWithOptions(baseRect.size, false, scale)
            draw(at: baseRect.origin)
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }

        private func flipped(_ closure: (CGContext) -> Void) -> UIImage {
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            guard let context = UIGraphicsGetCurrentContext() else { return self }
            closure(context)
            draw(at: .zero)
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }

        func flippedHorizontally() -> UIImage {
            flipped {
                $0.translateBy(x: size.width, y: 0)
                $0.scaleBy(x: -1, y: 1)
            }
        }

        func flippedVertically() -> UIImage {
            flipped {
                $0.translateBy(x: 0, y: size.height)
                $0.scaleBy(x: 1, y: -1)
            }
        }

        func resized(to newSize: CGSize, scale: CGFloat? = nil) -> UIImage {
            guard size.width > 0, size.height > 0 else { return .init() }
            let finalSize: CGSize
            let scale = scale ?? self.scale
            let ratio = size.width / size.height
            if ratio > 1 {
                let height = newSize.width / ratio
                finalSize = CGSize(width: newSize.width, height: height)
            } else {
                let width = newSize.height * ratio
                finalSize = CGSize(width: width, height: newSize.height)
            }
            UIGraphicsBeginImageContextWithOptions(finalSize, false, scale)
            draw(in: .init(origin: .zero, size: finalSize))
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }

        func resizedToFit(height: CGFloat, scale: CGFloat? = nil) -> UIImage {
            guard size.width > 0, size.height > 0 else { return .init() }

            let scale = scale ?? self.scale
            let ratio = size.width / size.height
            let finalSize: CGSize = .init(width: height * ratio, height: height)
//            if ratio > 1 {
//                let height = newSize.width / ratio
//                finalSize = CGSize(width: newSize.width, height: height)
//            } else {
//                let width = newSize.height * ratio
//                finalSize = CGSize(width: width, height: newSize.height)
//            }
            UIGraphicsBeginImageContextWithOptions(finalSize, false, scale)
            draw(in: .init(origin: .zero, size: finalSize))
            let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
            UIGraphicsEndImageContext()
            return image
        }

        func asRetina() -> UIImage {
            guard let cgImage else { return self }
            return .init(cgImage: cgImage, scale: 3.0, orientation: .up)
        }

        static func attributedText(_ attributedText: NSAttributedString,
                                   size: CGSize? = nil) -> UIImage {
            let textSize = attributedText.size()
            let size = size ?? textSize
            UIGraphicsBeginImageContextWithOptions(size, false, 0)
            let origin = CGPoint(x: 0, y: (size.height - textSize.height) / 2.0)
            attributedText.draw(in: .init(origin: origin, size: size))
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image ?? UIImage()
        }

        func badged(with text: NSAttributedString,
                    badgeRatio: CGFloat = 0.5,
                    badgeColor: UIColor = .red,
                    badgeBorderColor: UIColor,
                    badgeBorderWidth: CGFloat) -> UIImage {
            let circle = UIImage.circle(radius: (size.height * badgeRatio) / 2.0,
                                        strokeColor: badgeBorderColor,
                                        fillColor: badgeColor,
                                        lineWidth: badgeBorderWidth)
            let imgString = UIImage.attributedText(text)
            let horizontalPadding: CGFloat = circle.size.width / 2.0
            let verticalPadding: CGFloat = circle.size.height / 2.0 - 0

            let mainImage = insetted(by: .init(top: verticalPadding,
                                               left: horizontalPadding,
                                               bottom: verticalPadding,
                                               right: horizontalPadding))
            let finalImage = mainImage
                .overlaying(circle.overlaying(imgString),
                            at: CGPoint(x: mainImage.size.width - circle.size.width, y: 0))
            return finalImage
        }
    }
#endif

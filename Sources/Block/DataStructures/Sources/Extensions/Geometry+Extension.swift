import CoreGraphics
import Foundation

#if os(iOS) || os(tvOS) || os(watchOS)
    import UIKit
#else
    import AppKit

    extension EdgeInsets: Equatable {
        public static func == (lhs: NSEdgeInsets, rhs: NSEdgeInsets) -> Bool {
            lhs.left == rhs.left
                && lhs.right == rhs.right
                && lhs.top == rhs.top
                && lhs.bottom == rhs.bottom
        }

        static var zero: EdgeInsets { 0.insets }
    }
#endif

public extension Comparable {
    func trimmed(min minValue: Self, max maxValue: Self) -> Self {
        min(maxValue, max(self, minValue))
    }

    func trimmed(min minValue: Self) -> Self {
        max(minValue, self)
    }

    func trimmed(max maxValue: Self) -> Self {
        min(maxValue, self)
    }
}

public extension CGFloat {
    var rect: CGRect {
        CGRect(origin: .zero, size: size)
    }

    var size: CGSize {
        CGSize(width: self, height: self)
    }
}

public extension CGSize {
    var area: CGFloat {
        width * height
    }

    var isEmpty: Bool {
        area <= 0
    }

    var ratio: CGFloat {
        if height == 0 { return 0 }
        return width / height
    }
}

public extension CGRect {
    var area: CGFloat { size.area }

    var ratio: CGFloat { size.ratio }

    var isEmpty: Bool { size.isEmpty }
}

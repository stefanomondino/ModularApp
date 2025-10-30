import Foundation

public protocol ClosureInitializable: AnyObject {
    init()
}

extension NSObject: ClosureInitializable {}

public extension ClosureInitializable {
    init(_ closure: (Self) -> Void) {
        self.init()
        closure(self)
    }
}

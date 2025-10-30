import Foundation

public extension Data? {
    var orEmpty: Data {
        self ?? Data()
    }
}

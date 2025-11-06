//
// Images.swift
//

import Foundation
import AsyncAlgorithms
import Streams
import Logger
import DesignSystem

public typealias Image = DesignSystem.Image
public extension Logger.Tag {
    static var images: Self { "images" }
}

public typealias ImageStream = ShareableAsyncStream<Image?>

public protocol ImageStreamable: Sendable {
    func imageIdentifier() -> String
    func imageStream() -> ImageStream
}

public extension ImageStreamable where Self: AnyObject {
    func imageIdentifier() -> String {
        "\(Unmanaged.passUnretained(self).toOpaque())"
    }
}

extension DesignSystem.Image: ImageStreamable {
    public func imageStream() -> ImageStream {
        .just(self)
    }
}

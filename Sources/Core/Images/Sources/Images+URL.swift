//
//  Images+URL.swift
//  Images
//
//  Created by Stefano Mondino on 06/11/25.
//

import Kingfisher
import Streams
import Logger
import Foundation

extension URL: ImageStreamable {
    public func imageIdentifier() -> String {
        self.absoluteString
    }
    public func imageStream() -> ImageStream {
        ShareableAsyncStream { continuation in
            do {
                let image = try await KingfisherManager.shared.retrieveImage(with: self)
                continuation.yield(image.image)
            } catch {
                Logger.warning(error, tag: .images)
                continuation.yield(nil)
            }
            continuation.finish()
        }
    }
}

//
//  RemoteImage.swift
//  Images
//
//  Created by Stefano Mondino on 06/11/25.
//

//
//  RemoteImage.swift
//  CorePhone
//
//  Created by Stefano Mondino on 13/06/23.
//

import Foundation
import SwiftUI
import DataStructures
import Streams

public struct RemoteImage<Content: View>: View {
    
    fileprivate struct ImageBuilder: Sendable {

        let remoteImage: any ImageStreamable
        let isHighDensity: Bool
        
        @MainActor init?(remoteImage: (any ImageStreamable)?, isHighDensity: Bool = true) {
            guard let remoteImage else { return nil }
            self.remoteImage = remoteImage
            self.isHighDensity = isHighDensity
        }
        func imageStream() -> ImageStream {
            remoteImage.imageStream()
            //                .map { isHighDensity ? $0?.asRetina() : $0 }
                .asShareableStream()
        }
    }
    
    enum ImageResult: Sendable {
        case remoteImage(Image)
        case placeholder(Image)
        
        var image: Image {
            switch self {
            case let .remoteImage(image): image
            case let .placeholder(image): image
            }
        }
    }
    @Observable @MainActor
    final class ViewModel {
        var imageResult: ImageResult?
        var isDownloaded: Bool = false
        private var bag = TaskBag()
        fileprivate func reload(image: ImageBuilder?, placeholder: ImageBuilder?) {
            Task {
                guard let image = image ?? placeholder else { return }
                let startTime = Date()
                isDownloaded = false
                if imageResult == nil {
                    imageResult = .placeholder(Image.rectangle(rect: .init(origin: .zero, size: .init(width: 1, height: 1))))
                }
                if let placeholder {
                    for await value in placeholder.imageStream() {
                        if let value {
                            imageResult = .remoteImage(value)
                        }
                    }
                }
                for await value in image.imageStream() {
                    if let value {
                        
                        imageResult = .remoteImage(value)
                        if Date().timeIntervalSince(startTime) > 0.1 {
                            isDownloaded = true
                        }
                    }
                }
            }.store(in: bag)
        }
    }
    
    private var image: ImageBuilder?
    private let placeholder: ImageBuilder?
    let customization: (Customization) -> Content
    @State private var viewModel: ViewModel = .init()
    private let id: String
    public struct Customization {
        public var view: SwiftUI.Image {
            .init(uiImage: bitmap)
        }
        public let bitmap: Image
        public let isDownloaded: Bool
    }
    
    public init(_ remoteImage: (any ImageStreamable)?,
                isHighDensity: Bool = true,
                customizing customization: @escaping (Customization) -> Content) {
        image = ImageBuilder(remoteImage: remoteImage, isHighDensity: isHighDensity)
        placeholder = nil
        self.customization = customization
        self.id = remoteImage?.imageIdentifier() ?? UUID().uuidString
    }
    
//    var isDownloaded: Bool {
//        Date().timeIntervalSince(viewModel.startTime) > 0.1
//    }
    @State private var opacity: Double = 0.0
    public var body: some View {
        ZStack {
            if let imageResult = viewModel.imageResult {
                
                customization(.init(bitmap: imageResult.image, isDownloaded: viewModel.isDownloaded))
            }
        }
        .onChange(of: id) { oldValue, newValue in
            if oldValue != newValue {
                viewModel.reload(image: image, placeholder: placeholder)
            }
        }
        .onAppear {
            viewModel.reload(image: image, placeholder: placeholder)
        }
   
    }
}

#Preview {
    ZStack {
        RemoteImage(URL(string: "https://picsum.photos/1080/1920?t=\(Date().timeIntervalSince1970)"),
                    
                    isHighDensity: true) {
            $0.view.resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea()
                .fade(if: $0.isDownloaded)
        }
    }
}

struct FadeModifier: ViewModifier {
    @State private var fade: Bool = false
    func body(content: Content) -> some View {
        content
            .opacity(fade ? 1.0 : 0.0)
            .animation(.linear(duration: 0.5), value: fade)
            .onAppear {
                fade = true
            }
    }
}

extension View {
    @ViewBuilder
    public func fade(if condition: Bool) -> some View {
        if condition {
            modifier(FadeModifier())
        } else {
            self
        }
    }
}

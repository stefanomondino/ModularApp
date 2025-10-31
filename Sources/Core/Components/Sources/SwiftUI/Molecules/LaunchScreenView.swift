//
//  LaunchScreenView.swift
//  Components
//
//  Created by Stefano Mondino on 31/10/25.
//
#if os(iOS) || os(tvOS)
    import SwiftUI

    public struct LaunchScreenView: View {
        private struct Storyboard: UIViewControllerRepresentable {
            let name: String
            let bundle: Bundle
            func makeUIViewController(context _: Context) -> some UIViewController {
                UIStoryboard(name: name, bundle: bundle).instantiateInitialViewController() ?? .init()
            }

            func updateUIViewController(_: UIViewControllerType, context _: Context) {}
        }

        let name: String
        let bundle: Bundle
        public init(name: String = "LaunchScreen",
                    bundle: Bundle = .main) {
            self.name = name
            self.bundle = bundle
        }

        public var body: some View {
            Storyboard(name: name, bundle: bundle)
                .ignoresSafeArea()
        }
    }
#endif

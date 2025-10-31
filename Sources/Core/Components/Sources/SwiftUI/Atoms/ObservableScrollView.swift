//
//  ObservableScrollView.swift
//  Search_iOS
//
//  Created by Stefano Mondino on 12/05/23.
//

import Foundation
import SwiftUI

struct PositionObservingView<Content: View>: View {
    var coordinateSpace: CoordinateSpace
    @Binding var position: CGPoint
    @Binding var contentSize: CGSize
    @ViewBuilder var content: () -> Content

    var body: some View {
        content()
            .background(GeometryReader { geometry in
                Color.clear.preference(
                    key: PreferenceKey.self,
                    value: geometry.frame(in: coordinateSpace)
                )
            })
            .onPreferenceChange(PreferenceKey.self) { frame in
                position = frame.origin
                contentSize = frame.size
            }
    }
}

private extension PositionObservingView {
    struct PreferenceKey: SwiftUI.PreferenceKey {
        static var defaultValue: CGRect { .zero }

        static func reduce(value _: inout CGRect, nextValue _: () -> CGRect) {
            // No-op
        }
    }
}

public struct ObservableScrollView<Content: View>: View {
    public init(_ axes: Axis.Set = [.vertical],
                showsIndicators: Bool = true,
                offset: Binding<CGPoint>,
                contentSize: Binding<CGSize> = .constant(.zero),
                coordinateSpaceName: String = UUID().uuidString,
                content: @escaping () -> Content) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        _offset = offset
        _contentSize = contentSize
        self.coordinateSpaceName = coordinateSpaceName
        self.content = content
    }

    let coordinateSpaceName: String
    var axes: Axis.Set = [.vertical]
    var showsIndicators = true
    @Binding var offset: CGPoint
    @Binding var contentSize: CGSize
    @ViewBuilder var content: () -> Content

    // The name of our coordinate space doesn't have to be
    // stable between view updates (it just needs to be
    // consistent within this view), so we'll simply use a
    // plain UUID for it:

    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            PositionObservingView(
                coordinateSpace: .named(coordinateSpaceName),
                position: Binding(
                    get: { offset },
                    set: { newOffset in
                        offset = CGPoint(
                            x: -newOffset.x,
                            y: -newOffset.y
                        )
                    }
                ),
                contentSize: Binding(
                    get: { contentSize },
                    set: { newSize in
                        contentSize = .init(width: newSize.width,
                                            height: newSize.height)
                    }
                ),
                content: content
            )
        }
        .coordinateSpace(name: coordinateSpaceName)
    }
}

#Preview {
    @Previewable @State var contentOffset: CGPoint = .zero
    ObservableScrollView([.horizontal, .vertical],
                         offset: $contentOffset) {
        VStack {
            Color.red
        }
        .frame(width: 2000, height: 4000)
        .padding(16)
    }.overlay {
        Text("Offset: \(contentOffset.debugDescription)")
    }
}

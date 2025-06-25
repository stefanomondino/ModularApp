//
//  Number+SwiftUI.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 25/06/25.
//

import Foundation
import SwiftUI

public extension View {
//
//    func padding(_ edges: Edge.Set, _ value: NumberValue) -> some View {
//            padding(edges, value.doubleValue)
//    }
//
//    func padding(_ value: NumberValue) -> some View {
//            padding(value.doubleValue)
//    }

    func padding(_ edges: Edge.Set, _ key: NumberValue.Key, provider: NumberValue.Provider? = nil) -> some View {
        modifier(PaddingModifier(edges: edges, key: key, provider: provider))
    }

    func padding(_ key: NumberValue.Key, provider: NumberValue.Provider? = nil) -> some View {
        modifier(PaddingModifier(edges: nil, key: key, provider: provider))
    }

    func cornerRadius(_ key: NumberValue.Key, provider: NumberValue.Provider? = nil) -> some View {
        modifier(CornerRadiusModifier(key: key, provider: provider))
    }
}

struct PaddingModifier: ViewModifier {
    @Environment(\.design) var design: Design
    let edges: Edge.Set?
    let key: NumberValue.Key
    let provider: NumberValue.Provider?

    func body(content: Content) -> some View {
        if let edges {
            content.padding(edges, (provider ?? design.value).get(key).doubleValue)
        } else {
            content.padding((provider ?? design.value).get(key).doubleValue)
        }
    }
}

struct CornerRadiusModifier: ViewModifier {
    @Environment(\.design) var design: Design
    let key: NumberValue.Key
    let provider: NumberValue.Provider?

    func body(content: Content) -> some View {
        content.cornerRadius((provider ?? design.value).get(key).doubleValue)
    }
}

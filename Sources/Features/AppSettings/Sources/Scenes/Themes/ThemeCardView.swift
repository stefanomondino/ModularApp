//
//  Card.swift
//  AppSettings
//
//  Created by Stefano Mondino on 25/06/25.
//
import DesignSystem
import SwiftUI

// sourcery: AutoMockable
protocol ThemeItemViewModel {
    var theme: Theme { get }
    var id: String { get }
    var title: String { get }
    var colors: [String] { get }
}

extension Theme: ThemeItemViewModel {
    var title: String { text }
    var theme: Theme { self }
}

extension Themes {
    struct Card: View {
        @State var viewModel: ThemeItemViewModel
        @Environment(\.design) var design: Design
        init(viewModel: ThemeItemViewModel) {
            self.viewModel = viewModel
        }

        var body: some View {
            ZStack(alignment: .bottomLeading) {
                HStack(spacing: 0) {
                    ForEach(viewModel.colors, id: \.self) { color in
                        color.swiftUIColor
                    }
                }
                .aspectRatio(16 / 9, contentMode: .fill)
                Text(viewModel.title)
                    .typography(.h1, dynamic: true)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.secondary)
                    .padding(.sidePadding(2))
                    .background {
                        design.color.get(.background)
                            .swiftUIColor
                            .opacity(0.2)
                    }
            }

            .background(.background)
            .cornerRadius(.cornerRadius(1))
            .clipped()
        }
    }
}

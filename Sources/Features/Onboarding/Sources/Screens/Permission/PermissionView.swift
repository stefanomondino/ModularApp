//
//  PermissionView.swift
//  Onboarding
//
//  Created by Stefano Mondino on 04/11/25.
//

import Components
import DesignSystem
import Foundation
import SwiftUI

struct PermissionView<ViewModel: PermissionViewModel>: View {
    @State var viewModel: ViewModel
    var body: some View {
        ZStack {
            Color.yellow.ignoresSafeArea()
            Text(viewModel.title)
            Pill.Button("Activate", style: .standard) {
                viewModel.activate()
            }
        }.onFirstAppear {
            await viewModel.start()
        }
    }
}

#Preview(traits: .design(.baseTypography)) {
    PermissionView(viewModel: PermissionViewModelMock {
        $0.title = "Permission no"
    })
}

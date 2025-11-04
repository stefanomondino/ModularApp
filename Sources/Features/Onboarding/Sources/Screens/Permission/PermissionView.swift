//
//  PermissionView.swift
//  Onboarding
//
//  Created by Stefano Mondino on 04/11/25.
//

import Foundation
import SwiftUI
import DesignSystem

struct PermissionView<ViewModel: PermissionViewModel>: View {
    @State var viewModel: ViewModel
    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()
            Text(viewModel.title)
        }
    }
}

#Preview(traits: .design(.baseTypography)) {
    PermissionView(viewModel: PermissionViewModelMock {
        $0.title = "Permission Title"
    })
}

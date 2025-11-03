//
//  StartView.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 03/11/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import Foundation
import SwiftUI

struct StartView: View {
    @State var viewModel: StartViewModel
    var body: some View {
        VStack {
            Text("Welcome to the Modular App! Click me")
                .onTapGesture {
                    viewModel.goToAppSettings()
                }
        }
        .navigationStack(router: viewModel.router)
    }
}

//
//  StartView.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 03/11/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import Components
import Foundation
import Routes
import SwiftUI

/// An intermediate placeholder view deciding which is the next entrypoint of the app according to some business logic.
struct StartView: View {
    @State var viewModel: StartViewModel
    var body: some View {
        Color.clear.ignoresSafeArea()
            .onFirstAppear {
                await viewModel.start()
            }
    }
}

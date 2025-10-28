//
//  AppContainer+Networking.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 24/06/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import Foundation
import Networking

extension AppContainer {
    func setupNetworking() async {
        await register(scope: .singleton) { [self] in
            await Networking.Client()
        }
    }
}

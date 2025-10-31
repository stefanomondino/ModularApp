//
//  AppContainer+Environment.swift
//  ModularAppDev
//
//  Created by Stefano Mondino on 31/10/25.
//  Copyright © 2025 Stefano Mondino. All rights reserved.
//

import Foundation

protocol AppConfiguration: Sendable {}

extension EnvironmentImplementation: AppConfiguration {}

//
//  PermissionViewModel.swift
//  Onboarding
//
//  Created by Stefano Mondino on 04/11/25.
//
import Foundation
import Observation

// sourcery: AutoMockable
protocol PermissionViewModel {
    var title: String { get }
}

@Observable final class PermissionViewModelImplementation: PermissionViewModel {
    let title: String = "Permission"

    init() {}
}

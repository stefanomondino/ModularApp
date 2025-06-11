//
//  Color+SwiftUI.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import Foundation
import SwiftUI

public extension View {
    func foregroundColor(_ color: ColorConvertible) -> some View {
        foregroundStyle(color.swiftUIColor)
    }
}

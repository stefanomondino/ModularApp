//
//  LinearGradient.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

import Foundation
import SwiftUI

public struct LinearGradient: ColorConvertible {
    public struct Stop: Sendable {
        public var location: Double
        public var color: ColorConvertible
        public init(location: Double, color: ColorConvertible) {
            self.location = location
            self.color = color
        }
    }

    public var startPoint: UnitPoint
    public var endPoint: UnitPoint
    public var stops: [Stop]
    public init(stops: [Stop],
                startPoint: UnitPoint,
                endPoint: UnitPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        self.stops = stops
    }

    public init(colors: [ColorConvertible],
                startPoint: UnitPoint,
                endPoint: UnitPoint) {
        self.startPoint = startPoint
        self.endPoint = endPoint
        stops = colors.enumerated().map { index, color in
            Stop(location: Double(index) / Double(colors.count - 1), color: color)
        }
    }
}

public extension LinearGradient {
    func swiftUILinearGradient() -> SwiftUI.LinearGradient {
        .init(stops: stops.map { .init(color: $0.color.swiftUIColor,
                                       location: $0.location) },
              startPoint: startPoint,
              endPoint: endPoint)
    }

    var swiftUIColor: SwiftUI.Color {
        stops.first?.color.swiftUIColor ?? .clear
    }

    var hex: String { swiftUIColor.hex }
}

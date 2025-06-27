//
//  LinearGradient 2.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 13/06/25.
//
import SwiftUI

public struct RadialGradient: ColorConvertible {
    public struct Stop: Sendable {
        public var location: Double
        public var color: ColorConvertible
        public init(location: Double, color: ColorConvertible) {
            self.location = location
            self.color = color
        }
    }

    public var center: UnitPoint
    public var startRadius: CGFloat
    public var endRadius: CGFloat
    public var stops: [Stop]
    public init(stops: [Stop],
                center: UnitPoint,
                startRadius: CGFloat = 0,
                endRadius: CGFloat = 10) {
        self.stops = stops
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
    }

    public init(colors: [ColorConvertible],
                center: UnitPoint,
                startRadius: CGFloat = 0,
                endRadius: CGFloat = 10) {
        self.center = center
        self.startRadius = startRadius
        self.endRadius = endRadius
        stops = colors.enumerated().map { index, color in
            Stop(location: Double(index) / Double(colors.count - 1), color: color)
        }
    }
}

public extension RadialGradient {
    func swiftUIRadialGradient() -> SwiftUI.RadialGradient {
        SwiftUI.RadialGradient(stops: stops.map { .init(color: $0.color.swiftUIColor,
                                                        location: $0.location) },
                               center: center,
                               startRadius: startRadius,
                               endRadius: endRadius)
    }

    var swiftUIColor: SwiftUI.Color {
        stops.first?.color.swiftUIColor ?? .clear
    }

    var hex: String { swiftUIColor.hex }
}

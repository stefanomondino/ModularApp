//
//  UIColor+Extensions.swift
//  DesignSystem
//
//  Created by Stefano Mondino on 11/06/25.
//

//
//  UIColor+Extensions.swift
//  CorePlatform
//
//  Created by Stefano Mondino on 30/10/21.
//
#if canImport(UIKit)
    import Foundation
    import SwiftUI
    import UIKit

    extension String: ColorConvertible {
        public var swiftUIColor: Color {
            UIColor(hexString: self).swiftUIColor
        }

        public var hex: String { self }
    }

    extension UIColor: ColorConvertible {
        public var swiftUIColor: Color { .init(self) }

        public var hex: String {
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            getRed(&red, green: &green, blue: &blue, alpha: &alpha)

            let redInt = Int(red * 255)
            let greenInt = Int(green * 255)
            let blueInt = Int(blue * 255)
            return String(format: "#%02X%02X%02X", redInt, greenInt, blueInt)
        }
    }

    public extension ColorConvertible {
        // https://stackoverflow.com/a/47353477
        func isLight() -> Bool {
            guard let components = objectColor.cgColor.components, components.count > 2 else { return false }
            let brightness = ((components[0] * 299) + (components[1] * 587) + (components[2] * 114)) / 1000
            return brightness > 0.5
        }

        func isDark() -> Bool {
            !isLight()
        }

        var objectColor: UIColor {
            UIColor(swiftUIColor)
        }
    }

    public extension UIColor {
        /**
         Create a lighter color
         */
        func lighter(by percentage: CGFloat = 30.0) -> UIColor {
            adjustBrightness(by: abs(percentage))
        }

        /**
         Create a darker color
         */
        func darker(by percentage: CGFloat = 30.0) -> UIColor {
            adjustBrightness(by: -abs(percentage))
        }

        /**
         Try to increase brightness or decrease saturation
         */
        func adjustBrightness(by percentage: CGFloat = 30.0) -> UIColor {
            var hue: CGFloat = 0, saturation: CGFloat = 0, brightness: CGFloat = 0, alpha: CGFloat = 0
            if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
                if brightness < 1.0 {
                    let newBrightness: CGFloat = max(min(brightness + (percentage / 100.0) * brightness, 1.0), 0.0)
                    return UIColor(hue: hue, saturation: saturation, brightness: newBrightness, alpha: alpha)
                } else {
                    let newSaturation: CGFloat = min(max(saturation - (percentage / 100.0) * saturation, 0.0), 1.0)
                    return UIColor(hue: hue, saturation: newSaturation, brightness: brightness, alpha: alpha)
                }
            }
            return self
        }

        convenience init(hexString: String) {
            let red, green, blue, alpha: CGFloat

            if hexString.hasPrefix("#") {
                let start = hexString.index(hexString.startIndex, offsetBy: 1)
                let hexColor = hexString[start...]

                var hexColorWithAlpha = String(hexColor)
                if hexColorWithAlpha.count == 6 {
                    hexColorWithAlpha = "\(hexColorWithAlpha)FF"
                }

                let scanner = Scanner(string: hexColorWithAlpha)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    red = CGFloat((hexNumber & 0xFF00_0000) >> 24) / 255
                    green = CGFloat((hexNumber & 0x00FF_0000) >> 16) / 255
                    blue = CGFloat((hexNumber & 0x0000_FF00) >> 8) / 255
                    alpha = CGFloat(hexNumber & 0x0000_00FF) / 255

                    self.init(red: red, green: green, blue: blue, alpha: alpha)
                    return
                }
            }

            self.init(red: 0, green: 0, blue: 0, alpha: 1)
            return
        }

        func interpolate(with color: UIColor, percentage: CGFloat) -> UIColor {
            var startRed: CGFloat = 0.0, startGreen: CGFloat = 0.0, startBlue: CGFloat = 0.0, startAlpha: CGFloat = 0.0
            var endRed: CGFloat = 0.0, endGreen: CGFloat = 0.0, endBlue: CGFloat = 0.0, endAlpha: CGFloat = 0.0

            getRed(&startRed, green: &startGreen, blue: &startBlue, alpha: &startAlpha)
            color.getRed(&endRed, green: &endGreen, blue: &endBlue, alpha: &endAlpha)

            let interpolatedRed = startRed + (endRed - startRed) * percentage
            let interpolatedGreen = startGreen + (endGreen - startGreen) * percentage
            let interpolatedBlue = startBlue + (endBlue - startBlue) * percentage
            let interpolatedAlpha = startAlpha + (endAlpha - startAlpha) * percentage

            return UIColor(red: interpolatedRed,
                           green: interpolatedGreen,
                           blue: interpolatedBlue,
                           alpha: interpolatedAlpha)
        }
    }
#endif

//
//  UIColor+Hex.swift
//  EZUI
//
//  Created by Augusto Avelino on 13/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

public extension UIColor {
    convenience init(patternImage: UIImage, tintColor: UIColor) {
        var image = patternImage.withRenderingMode(.alwaysTemplate)
        UIGraphicsBeginImageContextWithOptions(patternImage.size, false, patternImage.scale)
        tintColor.set()
        image.draw(in: CGRect(
            origin: .zero,
            size: image.size
        ))
        image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        self.init(patternImage: image)
    }
    
    convenience init(rgb: Int) {
        let red = CGFloat((rgb >> 16) & 0xFF) / 255.0
        let green = CGFloat((rgb >> 8) & 0xFF) / 255.0
        let blue = CGFloat(rgb & 0xFF) / 255.0
        self.init(
            red: max(0.0, min(red, 1.0)),
            green: max(0.0, min(green, 1.0)),
            blue: max(0.0, min(blue, 1.0)),
            alpha: 1.0
        )
    }
    
    convenience init(rgba: Int) {
        let red = CGFloat((rgba >> 24) & 0xFF) / 255.0
        let green = CGFloat((rgba >> 16) & 0xFF) / 255.0
        let blue = CGFloat((rgba >> 8) & 0xFF) / 255.0
        let alpha = CGFloat(rgba & 0xFF) / 255.0
        self.init(
            red: max(0.0, min(red, 1.0)),
            green: max(0.0, min(green, 1.0)),
            blue: max(0.0, min(blue, 1.0)),
            alpha: max(0.0, min(alpha, 1.0))
        )
    }
    
    convenience init(darkRGB: Int, lightRGB: Int) {
        self.init { trait in
            if trait.userInterfaceStyle == .light {
                return UIColor(rgb: lightRGB)
            } else {
                return UIColor(rgb: darkRGB)
            }
        }
    }
    
    convenience init(darkRGBA: Int, lightRGBA: Int) {
        self.init { trait in
            if trait.userInterfaceStyle == .light {
                return UIColor(rgba: lightRGBA)
            } else {
                return UIColor(rgba: darkRGBA)
            }
        }
    }
    
    func rgbString(prefix: String = "#", uppercase: Bool = true) -> String {
        return prefix + String(rgbInt(), radix: 16, uppercase: uppercase).leftPadding(toLength: 6, withPad: "0")
    }
    
    func rgbaString(prefix: String = "#", uppercase: Bool = true) -> String {
        return prefix + String(rgbaInt(), radix: 16, uppercase: uppercase).leftPadding(toLength: 8, withPad: "0")
    }
    
    func rgbInt() -> Int {
        var cgRed: CGFloat = 1.0
        var cgGreen: CGFloat = 1.0
        var cgBlue: CGFloat = 1.0
        getRed(&cgRed, green: &cgGreen, blue: &cgBlue, alpha: nil)
        return UIColor.makeRGBInt(red: cgRed, green: cgGreen, blue: cgBlue)
    }
    
    func rgbaInt() -> Int {
        var cgRed: CGFloat = 1.0
        var cgGreen: CGFloat = 1.0
        var cgBlue: CGFloat = 1.0
        var cgAlpha: CGFloat = 1.0
        getRed(&cgRed, green: &cgGreen, blue: &cgBlue, alpha: &cgAlpha)
        return UIColor.makeRGBAInt(red: cgRed, green: cgGreen, blue: cgBlue, alpha: cgAlpha)
    }
    
    static func getRedInt(fromRGBA rgba: Int) -> Int {
        return (rgba >> 24) & 0xFF
    }
    
    static func getGreenInt(fromRGBA rgba: Int) -> Int {
        return (rgba >> 16) & 0xFF
    }
    
    static func getBlueInt(fromRGBA rgba: Int) -> Int {
        return (rgba >> 8) & 0xFF
    }
    
    static func getAlphaInt(fromRGBA rgba: Int) -> Int {
        return rgba & 0xFF
    }
    
    private static func makeRGBInt(red: CGFloat, green: CGFloat, blue: CGFloat) -> Int {
        let safeRed = max(0.0, min(red, 1.0))
        let safeGreen =  max(0.0, min(green, 1.0))
        let safeBlue =  max(0.0, min(blue, 1.0))
        let intRed = Int((safeRed * 255.0).rounded()) << 16
        let intGreen = Int((safeGreen * 255.0).rounded()) << 8
        let intBlue = Int((safeBlue * 255.0).rounded())
        return intRed + intGreen + intBlue
    }
    
    private static func makeRGBAInt(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> Int {
        let safeRed = max(0.0, min(red, 1.0))
        let safeGreen =  max(0.0, min(green, 1.0))
        let safeBlue =  max(0.0, min(blue, 1.0))
        let safeAlpha =  max(0.0, min(alpha, 1.0))
        let intRed = Int((safeRed * 255.0).rounded()) << 24
        let intGreen = Int((safeGreen * 255.0).rounded()) << 16
        let intBlue = Int((safeBlue * 255.0).rounded()) << 8
        let intAlpha = Int((safeAlpha * 255.0).rounded())
        return intRed + intGreen + intBlue + intAlpha
    }
}

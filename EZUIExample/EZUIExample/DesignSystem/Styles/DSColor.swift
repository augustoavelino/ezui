//
//  DSColor.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 28/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

extension UIColor {
    static func dsColor(_ dsColor: DSColor) -> UIColor {
        return UIColor(
            darkRGBA: dsColor.rgba.dark,
            lightRGBA: dsColor.rgba.light
        )
    }
    
    func textColor() -> UIColor? {
        let (white, alpha) = getWhiteAndAlpha()
        let isAlphaLow = alpha <= 0.5
        let isBackgroundBright = white >= 0.5
        if isAlphaLow {
            return .label
        } else {
            return isBackgroundBright ? .black : .white
        }
    }
    
    func secondaryTextColor() -> UIColor? {
        let (white, alpha) = getWhiteAndAlpha()
        let isAlphaLow = alpha <= 0.5
        let isBackgroundBright = white >= 0.5
        if isAlphaLow {
            return .secondaryLabel
        } else {
            return isBackgroundBright ? .darkGray : .lightGray
        }
    }
    
    fileprivate func getWhiteAndAlpha() -> (white: CGFloat, alpha: CGFloat) {
        var white: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        getWhite(&white, alpha: &alpha)
        return (white, alpha)
    }
}

protocol DSColorProtocol {
    typealias RGBAValues = (dark: Int, light: Int)
    var rgba: RGBAValues { get }
}

enum DSColor: DSColorProtocol {
    
    case background(Background)
    case label(Label)
    
    var rgba: RGBAValues {
        switch self {
        case .background(let background): return background.rgba
        case .label(let label): return label.rgba
        }
    }
    
    enum Background: DSColorProtocol {
        case primary, secondary
        
        var rgba: RGBAValues {
            switch self {
            case .primary: return (0x000000FF, 0xFFFFFFFF)
            case .secondary: return (0x1C1C1CFF, 0xCCCCCCFF)
            }
        }
    }
    
    enum Label: DSColorProtocol {
        case primary, secondary
        
        var rgba: RGBAValues {
            switch self {
            case .primary: return (0x000000FF, 0xFFFFFFFF)
            case .secondary: return (0x1C1C1CFF, 0xCCCCCCFF)
            }
        }
    }
}

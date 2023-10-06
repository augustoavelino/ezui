//
//  DSFont.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 12/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

enum DSFont: EZFont {
    static func preferredFont(forTextStyle style: UIFont.TextStyle) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: style)
        switch style {
        case .largeTitle, .title2, .headline: return .systemFont(ofSize: font.pointSize, weight: .bold)
        case .callout: return .systemFont(ofSize: font.pointSize, weight: .semibold)
        default: return .systemFont(ofSize: font.pointSize, weight: .regular)
        }
    }
    
    static func preferredFont(forTextStyle style: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection?) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: style, compatibleWith: traitCollection)
        switch style {
        case .largeTitle, .title2, .headline: return .systemFont(ofSize: font.pointSize, weight: .bold)
        case .callout: return .systemFont(ofSize: font.pointSize, weight: .semibold)
        default: return .systemFont(ofSize: font.pointSize, weight: .regular)
        }
    }
}

enum DSMonospacedFont: EZFont {
    static func preferredFont(forTextStyle style: UIFont.TextStyle) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: style)
        switch style {
        case .largeTitle, .title2, .headline: return makeFiraCode(ofSize: font.pointSize, weight: .bold)
        case .callout: return makeFiraCode(ofSize: font.pointSize, weight: .semibold)
        default: return makeFiraCode(ofSize: font.pointSize, weight: .regular)
        }
    }
    
    static func preferredFont(forTextStyle style: UIFont.TextStyle, compatibleWith traitCollection: UITraitCollection?) -> UIFont {
        let font = UIFont.preferredFont(forTextStyle: style, compatibleWith: traitCollection)
        switch style {
        case .largeTitle, .title2, .headline: return makeFiraCode(ofSize: font.pointSize, weight: .bold)
        case .callout: return makeFiraCode(ofSize: font.pointSize, weight: .semibold)
        default: return makeFiraCode(ofSize: font.pointSize, weight: .regular)
        }
    }
    
    private static func makeFiraCode(ofSize fontSize: CGFloat, weight: UIFont.Weight) -> UIFont {
        return UIFont(name: "Fira Code", size: fontSize) ?? .monospacedSystemFont(ofSize: fontSize, weight: weight)
    }
}

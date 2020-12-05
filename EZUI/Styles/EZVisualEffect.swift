//
//  EZVisualEffect.swift
//  EZUI
//
//  Created by Augusto Avelino on 04/12/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

public enum EZVisualEffect {
    // MARK: Cases
    case blur(style: UIBlurEffect.Style)
    
    @available(iOS 13.0, *)
    case vibrancy(blurStyle: UIBlurEffect.Style, style: UIVibrancyEffectStyle)
    
    // MARK: Properties
    var visualEffect: UIVisualEffect? {
        switch self {
        case .blur(let style): return UIBlurEffect(style: style)
            
        case .vibrancy(let blurStyle, let style):
            if #available(iOS 13.0, *) {
                return UIVibrancyEffect(blurEffect: UIBlurEffect(style: blurStyle), style: style)
            }
        }
        return nil
    }
}

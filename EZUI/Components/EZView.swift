//
//  EZView.swift
//  EZUI
//
//  Created by Augusto Avelino on 11/07/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

public enum EZVisualEffect {
    case blur(style: UIBlurEffect.Style)
    
    @available(iOS 13.0, *)
    case vibrancy(blurStyle: UIBlurEffect.Style, style: UIVibrancyEffectStyle)
    
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

open class EZView: UIView {
    private var _visualEffect: EZVisualEffect?
    open var visualEffect: EZVisualEffect? {
        get { return _visualEffect }
        set { applyVisualEffect(newValue) }
    }
    
    open func applyVisualEffect(_ newEffect: EZVisualEffect?) {
        subviews.compactMap { $0 as? UIVisualEffectView }.forEach { $0.removeFromSuperview() }
        _visualEffect = newEffect
        let effectView = UIVisualEffectView(effect: newEffect?.visualEffect)
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(effectView)
    }
}

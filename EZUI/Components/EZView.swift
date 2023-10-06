//
//  EZView.swift
//  EZUI
//
//  Created by Augusto Avelino on 11/07/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZView: UIView {
    
    // MARK: Properties
    
    private var _visualEffect: EZVisualEffect?
    open var visualEffect: EZVisualEffect? {
        get { return _visualEffect }
        set { applyVisualEffect(newValue) }
    }
    
    // MARK: - Life cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Display updates
    
    open func applyVisualEffect(_ newEffect: EZVisualEffect?) {
        subviews.compactMap { $0 as? UIVisualEffectView }.forEach { $0.removeFromSuperview() }
        _visualEffect = newEffect
        let effectView = UIVisualEffectView(effect: newEffect?.visualEffect)
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(effectView)
    }
    
    // MARK: - Setup
    
    open func setupUI() {}
}

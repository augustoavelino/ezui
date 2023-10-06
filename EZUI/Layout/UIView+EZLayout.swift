//
//  UIView+Layout.swift
//  EZUI
//
//  Created by Augusto Avelino on 14/03/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

// Based on John Sundell's DSL tutorial.
// (https://www.swiftbysundell.com/articles/building-dsls-in-swift/)

import UIKit

public extension UIView {
    func layout(_ closure: (EZLayoutProxy) -> Void) {
        translatesAutoresizingMaskIntoConstraints = false
        closure(EZLayoutProxy(view: self))
    }
    
    func layoutFillSuperview(topPadding: CGFloat = 0.0, leadingPadding: CGFloat = 0.0, trailingPadding: CGFloat = 0.0, bottomPadding: CGFloat = 0.0) {
        guard let superview = superview else { return }
        layout {
            $0.top == superview.topAnchor + topPadding
            $0.leading == superview.leadingAnchor + leadingPadding
            $0.trailing == superview.trailingAnchor - trailingPadding
            $0.bottom == superview.bottomAnchor - bottomPadding
        }
    }
    
    func layoutFillSuperview(horizontalPadding: CGFloat = 0.0, verticalPadding: CGFloat = 0.0) {
        layoutFillSuperview(topPadding: verticalPadding, leadingPadding: horizontalPadding, trailingPadding: horizontalPadding, bottomPadding: verticalPadding)
    }
    
    func layoutFillSuperview(padding: CGFloat = 0.0) {
        layoutFillSuperview(horizontalPadding: padding, verticalPadding: padding)
    }
}

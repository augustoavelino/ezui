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
    
    func layoutFillSuperview() {
        guard let superview = superview else { return }
        layout {
            $0.top == superview.topAnchor
            $0.leading == superview.leadingAnchor
            $0.trailing == superview.trailingAnchor
            $0.bottom == superview.bottomAnchor
        }
    }
}

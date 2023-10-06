//
//  UIBarButtonItem+Extensions.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 23/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

public extension UIBarButtonItem {
    static func safeFlexibleSpace() -> UIBarButtonItem {
        var flexibleSpace: UIBarButtonItem
        if #available(iOS 14.0, *) {
            flexibleSpace = .flexibleSpace()
        } else {
            flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        }
        return flexibleSpace
    }
}

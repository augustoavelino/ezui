//
//  EZFont.swift
//  EZUI
//
//  Created by Augusto Avelino on 07/08/22.
//  Copyright © 2022 Augusto Avelino. All rights reserved.
//

import UIKit

public protocol EZFont {
    static func preferredFont(forTextStyle style: UIFont.TextStyle) -> UIFont
}

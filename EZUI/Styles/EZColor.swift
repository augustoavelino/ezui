//
//  EZColor.swift
//  EZUI
//
//  Created by Augusto Avelino on 29/02/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

// MARK: Protocol
public protocol EZColor {
    // MARK: Properties
    var uiColor: UIColor { get }
    var cgColor: CGColor { get }
    var ciColor: CIColor { get }
    
    // MARK: Static methods
    static func from(_ color: UIColor?) -> EZColor?
    static func from(_ color: CGColor?) -> EZColor?
    static func from(_ color: CIColor?) -> EZColor?
}

// MARK: - Extension
public extension EZColor {
    var cgColor: CGColor {
        return uiColor.cgColor
    }
    
    var ciColor: CIColor {
        return uiColor.ciColor
    }
    
    static func from(_ color: CGColor?) -> EZColor? {
        guard let color = color else { return nil }
        return from(UIColor(cgColor: color))
    }
    
    static func from(_ color: CIColor?) -> EZColor? {
        guard let color = color else { return nil }
        return from(UIColor(ciColor: color))
    }
}

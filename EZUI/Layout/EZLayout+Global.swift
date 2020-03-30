//
//  EZLayout+Global.swift
//  EZUI
//
//  Created by Augusto Avelino on 14/03/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

// Based on John Sundell's DSL tutorial.
// (https://www.swiftbysundell.com/articles/building-dsls-in-swift/)

import UIKit

public func +(lhs: inout NSLayoutConstraint, rhs: CGFloat) {
    lhs.constant += rhs
}

public func -(lhs: inout NSLayoutConstraint, rhs: CGFloat) {
    lhs.constant -= rhs
}

public extension EZLayoutAnchor {
    // MARK: Constants
    static func +(lhs: Self, rhs: CGFloat) -> (Self, CGFloat) {
        return (lhs, rhs)
    }

    static func -(lhs: Self, rhs: CGFloat) -> (Self, CGFloat) {
        return (lhs, -rhs)
    }
    
    // TODO: Find a way to implement multiplier (and constant)
}

public extension EZLayoutProperty {
    // MARK: Equal
    @discardableResult
    static func ==(lhs: Self, rhs: EZAnchor) -> NSLayoutConstraint {
        return lhs.equal(to: rhs)
    }

    @discardableResult
    static func ==(lhs: Self, rhs: (EZAnchor, CGFloat)) -> NSLayoutConstraint {
        return lhs.equal(to: rhs.0, offsetBy: rhs.1)
    }

    // MARK: Greater than or equal to
    @discardableResult
    static func >=(lhs: Self, rhs: EZAnchor) -> NSLayoutConstraint {
        return lhs.greaterThanOrEqual(to: rhs)
    }
    
    @discardableResult
    static func >=(lhs: Self, rhs: (EZAnchor, CGFloat)) -> NSLayoutConstraint {
        return lhs.greaterThanOrEqual(to: rhs.0, offsetBy: rhs.1)
    }

    // MARK: Less than or equal to
    @discardableResult
    static func <=(lhs: Self, rhs: EZAnchor) -> NSLayoutConstraint {
        return lhs.lessThanOrEqual(to: rhs)
    }
    
    @discardableResult
    static func <=(lhs: Self, rhs: (EZAnchor, CGFloat)) -> NSLayoutConstraint {
        return lhs.lessThanOrEqual(to: rhs.0, offsetBy: rhs.1)
    }
}

public extension EZLayoutProperty where EZAnchor: EZLayoutDimension {
    @discardableResult
    static func ==(lhs: Self, rhs: CGFloat) -> NSLayoutConstraint {
        return lhs.equal(toConstant: rhs)
    }

    @discardableResult
    static func >=(lhs: Self, rhs: CGFloat) -> NSLayoutConstraint {
        return lhs.greaterThanOrEqual(toConstant: rhs)
    }

    @discardableResult
    static func <=(lhs: Self, rhs: CGFloat) -> NSLayoutConstraint {
        return lhs.lessThanOrEqual(toConstant: rhs)
    }
}

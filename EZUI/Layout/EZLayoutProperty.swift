//
//  EZLayoutProperty.swift
//  EZUI
//
//  Created by Augusto Avelino on 14/03/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

// Based on John Sundell's DSL tutorial.
// (https://www.swiftbysundell.com/articles/building-dsls-in-swift/)

import UIKit

// MARK: Property
public struct EZLayoutProperty<EZAnchor: EZLayoutAnchor> {
    let anchor: EZAnchor
}

// MARK: - Generic relations
public extension EZLayoutProperty {
    @discardableResult
    func equal(to otherAnchor: EZAnchor, offsetBy constant: CGFloat = 0.0, with priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(equalTo: otherAnchor, constant: constant)
        if let priority = priority { constraint.priority = priority }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func greaterThanOrEqual(to otherAnchor: EZAnchor, offsetBy constant: CGFloat = 0.0, with priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(greaterThanOrEqualTo: otherAnchor, constant: constant)
        if let priority = priority { constraint.priority = priority }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func lessThanOrEqual(to otherAnchor: EZAnchor, offsetBy constant: CGFloat = 0.0, with priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(lessThanOrEqualTo: otherAnchor, constant: constant)
        if let priority = priority { constraint.priority = priority }
        constraint.isActive = true
        return constraint
    }
}

// MARK: - Dimension relations
public extension EZLayoutProperty where EZAnchor: EZLayoutDimension {
    // MARK: Equal
    @discardableResult
    func equal(toConstant constant: CGFloat, with priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(equalToConstant: constant)
        if let priority = priority { constraint.priority = priority }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func equal(to otherAnchor: EZAnchor, multiplier: CGFloat = 1.0, with priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(equalTo: otherAnchor, multiplier: multiplier)
        if let priority = priority { constraint.priority = priority }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func equal(to otherAnchor: EZAnchor, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0, with priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(equalTo: otherAnchor, multiplier: multiplier, constant: constant)
        if let priority = priority { constraint.priority = priority }
        constraint.isActive = true
        return constraint
    }
    
    // MARK: Greater
    @discardableResult
    func greaterThanOrEqual(toConstant constant: CGFloat, with priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(greaterThanOrEqualToConstant: constant)
        if let priority = priority { constraint.priority = priority }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func greaterThanOrEqual(to otherAnchor: EZAnchor, multiplier: CGFloat = 1.0, with priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(greaterThanOrEqualTo: otherAnchor, multiplier: multiplier)
        if let priority = priority { constraint.priority = priority }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func greaterThanOrEqual(to otherAnchor: EZAnchor, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0, with priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(greaterThanOrEqualTo: otherAnchor, multiplier: multiplier, constant: constant)
        if let priority = priority { constraint.priority = priority }
        constraint.isActive = true
        return constraint
    }
    
    // MARK: Less
    @discardableResult
    func lessThanOrEqual(toConstant constant: CGFloat, with priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(lessThanOrEqualToConstant: constant)
        if let priority = priority { constraint.priority = priority }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func lessThanOrEqual(to otherAnchor: EZAnchor, multiplier: CGFloat = 1.0, with priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(lessThanOrEqualTo: otherAnchor, multiplier: multiplier)
        if let priority = priority { constraint.priority = priority }
        constraint.isActive = true
        return constraint
    }
    
    @discardableResult
    func lessThanOrEqual(to otherAnchor: EZAnchor, multiplier: CGFloat = 1.0, constant: CGFloat = 0.0, with priority: UILayoutPriority? = nil) -> NSLayoutConstraint {
        let constraint = anchor.constraint(lessThanOrEqualTo: otherAnchor, multiplier: multiplier, constant: constant)
        if let priority = priority { constraint.priority = priority }
        constraint.isActive = true
        return constraint
    }
}

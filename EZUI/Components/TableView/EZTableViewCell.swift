//
//  EZTableViewCell.swift
//  EZUI
//
//  Created by Augusto Avelino on 01/02/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

public protocol EZTableViewCellType: class {
    static var reuseIdentifier: String { get }
    
    associatedtype EZTableViewCellData
    func present(data: EZTableViewCellData)
}

// MARK: -
public extension EZTableViewCellType {
    static var reuseIdentifier: String { return "\(type(of: self))" }
}

// MARK: -
public class EZTableViewCell: UITableViewCell, EZTableViewCellType {
    public typealias EZTableViewCellData = String
    
    // MARK: Presentation
    public func present(data: String) {
        textLabel?.text = data
    }
}

//
//  EZTableViewCell.swift
//  EZUI
//
//  Created by Augusto Avelino on 01/02/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZTableViewCell: UITableViewCell {
    // MARK: Class properties
    open class var reuseIdentifier: String { "\(Self.self)" }
    
    // MARK: - Life cycle
    override public init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  DSMenuItemCell.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 09/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

struct DSMenuItemCellData {
    var icon: UIImage?
    let title: String
}

class DSMenuItemCell: EZTableViewCell {
    
    // MARK: - Setup
    
    override func setupUI() {
        accessoryType = .disclosureIndicator
    }
    
    // MARK: - Configure
    
    func configure(_ cellData: DSMenuItemCellData) {
        imageView?.image = cellData.icon
        textLabel?.text = cellData.title
    }
}

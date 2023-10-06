//
//  DSMenuTableView.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 10/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class DSMenuTableView: EZTableView {
    
    // MARK: Life cycle
    
    init() {
        super.init(cellClass: DSMenuItemCell.self, style: .insetGrouped, separatorStyle: .singleLine)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

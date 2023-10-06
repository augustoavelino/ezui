//
//  ColorPaletteDetailCell.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 10/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

struct ColorPaletteDetailCellData: ColorPaletteDetailCellDataProtocol {
    let name: String
    let color: UIColor
}

class ColorPaletteDetailCell: EZTableViewCell {
    
    // MARK: UI
    
    let colorView = DSColorView()
    
    // MARK: - Setup
    
    override func setupUI() {
        setupColorView()
    }
    
    func setupColorView() {
        contentView.addSubview(colorView)
        colorView.layoutFillSuperview(
            horizontalPadding: 16.0,
            verticalPadding: 6.0
        )
    }
    
    // MARK: - Configure
    
    func configure(_ cellData: ColorPaletteDetailCellDataProtocol) {
        colorView.name = cellData.name
        colorView.color = cellData.color
    }
}

//
//  TypographyDemoCell.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 09/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

struct TypographyDemoCellData: TypographyDemoCellDataProtocol {
    let labelText: String
    let textStyle: UIFont.TextStyle
}

class TypographyDemoCell: EZTableViewCell {
    
    // MARK: UI
    
    lazy var stackView = EZStackView(
        distribution: .fillEqually,
        spacing: 8.0,
        arrangedSubviews: [primaryLabel, secondaryLabel]
    )
    lazy var primaryLabel = DSLabel(textAlignment: .right)
    lazy var secondaryLabel = DSLabel(textColor: .secondaryLabel)
    
    // MARK: - Setup
    
    override func setupUI() {
        setupStackView()
    }
    
    func setupStackView() {
        contentView.addSubview(stackView)
        stackView.layoutFillSuperview(
            horizontalPadding: 16.0,
            verticalPadding: 8.0
        )
    }
    
    // MARK: - Configure
    
    func configure(_ cellData: TypographyDemoCellDataProtocol) {
        primaryLabel.text = cellData.labelText
        primaryLabel.textStyle = cellData.textStyle
        secondaryLabel.text = cellData.labelText
        secondaryLabel.textStyle = cellData.textStyle
    }
}

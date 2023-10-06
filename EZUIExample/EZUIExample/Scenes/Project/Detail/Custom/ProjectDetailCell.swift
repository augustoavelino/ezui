//
//  ProjectDetailCell.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 09/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

struct ProjectDetailCellData: ProjectDetailCellDataProtocol {
    let iconName: String
    let title: String
}

class ProjectDetailCell: EZCollectionViewCell {
    
    // MARK: UI
    
    lazy var stackView = EZStackView(
        axis: .vertical,
        arrangedSubviews: [iconBackgroundView, titleLabel,]
    )
    lazy var iconBackgroundView = UIView()
    lazy var iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    lazy var titleLabel: DSLabel = {
        let label = DSLabel(
            textAlignment: .center,
            textStyle: .subheadline,
            numberOfLines: 0
        )
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        label.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        return label
    }()
    
    // MARK: Setup
    
    override func setupUI() {
        setupStackView()
        setupIconImageView()
    }
    
    func setupStackView() {
        contentView.addSubview(stackView)
        stackView.layoutFillSuperview(padding: 4.0)
    }
    
    func setupIconImageView() {
        iconBackgroundView.addSubview(iconImageView)
        let padding = 24.0
        iconImageView.layout {
            $0.top == iconBackgroundView.topAnchor + padding
            $0.bottom == iconBackgroundView.bottomAnchor - padding / 2.0
            $0.leading == iconBackgroundView.leadingAnchor + padding
            $0.trailing == iconBackgroundView.trailingAnchor - padding
//            $0.centerX == iconBackgroundView.centerXAnchor
//            $0.width == 64.0
//            $0.height == 64.0
        }
    }
    
    // MARK: - Configure
    
    func configure(_ cellData: ProjectDetailCellDataProtocol, tintColor: UIColor) {
        let cellImage = UIImage(systemName: cellData.iconName)
        if #available(iOS 15.0, *) {
            iconImageView.image = cellImage?.applyingSymbolConfiguration(.preferringMulticolor())
        } else {
            iconImageView.image = cellImage
        }
        titleLabel.text = cellData.title
    }
}

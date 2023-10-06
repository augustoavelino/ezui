//
//  ProjectListCell.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 01/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

struct ProjectListCellData: ProjectListCellDataProtocol {
    let name: String
    let image: UIImage?
    let dateCreatedText: String?
    let dateUpdatedText: String?
}

class ProjectListCell: EZCollectionViewCell {
    
    // MARK: UI
    
    lazy var roundedView: UIView = {
        let view = UIView()
        view.cornerRadius = 10.0
        return view
    }()
    lazy var stackView = EZStackView(
        axis: .vertical,
        arrangedSubviews: [bannerImageView, bottomView,]
    )
    lazy var bannerImageView = ProjectBannerImageView(
        bannerSize: .small,
        projectName: nil,
        bannerImage: nil
    )
    lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(bottomStackView)
        bottomStackView.layoutFillSuperview(padding: 8.0)
        return view
    }()
    lazy var bottomStackView = EZStackView(
        axis: .vertical,
        spacing: 8.0,
        arrangedSubviews: [nameLabel, dateStackView,]
    )
    lazy var nameLabel = DSLabel(textStyle: .callout)
    lazy var dateStackView = EZStackView(
        axis: .vertical,
        spacing: 2.0,
        arrangedSubviews: [dateCreatedLabel, dateUpdatedLabel,]
    )
    lazy var dateCreatedLabel = DSLabel(
        textStyle: .caption1,
        textColor: .secondaryLabel
    )
    lazy var dateUpdatedLabel = DSLabel(
        textStyle: .caption1,
        textColor: .secondaryLabel
    )
    
    // MARK: - Setup
    
    override func setupUI() {
        setupRoundedView()
        setupStackView()
    }
    
    func setupRoundedView() {
        contentView.addSubview(roundedView)
        roundedView.layoutFillSuperview()
    }
    
    func setupStackView() {
        roundedView.addSubview(stackView)
        stackView.layoutFillSuperview()
    }
    
    // MARK: - Configure
    
    func configure(cellData: ProjectListCellDataProtocol, tintColor: UIColor) {
        nameLabel.text = cellData.name
        bannerImageView.set(
            projectName: cellData.name,
            bannerImage: cellData.image
        )
        bannerImageView.backgroundColor = tintColor
        dateCreatedLabel.text = cellData.dateCreatedText
        dateUpdatedLabel.text = cellData.dateUpdatedText
    }
}

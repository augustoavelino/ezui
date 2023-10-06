//
//  ProjectDetailHeaderView.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 06/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

struct ProjectDetailHeaderViewData: ProjectDetailHeaderViewDataProtocol {
    let projectName: String?
    let bannerImage: UIImage?
}

class ProjectDetailHeaderView: EZView {
    
    var bannerBackgroundColor: UIColor? {
        get { bannerImageView.backgroundColor }
        set { bannerImageView.backgroundColor = newValue }
    }
    
    // MARK: UI
    
    lazy var stackView = EZStackView(
        axis: .vertical,
        spacing: 16.0,
        arrangedSubviews: [bannerImageView, projectNameView,]
    )
    lazy var bannerImageView = ProjectBannerImageView(bannerSize: .large)
    lazy var projectNameView = UIView()
    lazy var projectNameLabel = DSLabel(
        textStyle: .largeTitle,
        numberOfLines: 0
    )
    
    // MARK: - Setup
    
    override func setupUI() {
        setupStackView()
        setupProjectNameLabel()
    }
    
    func setupStackView() {
        addSubview(stackView)
        stackView.layoutFillSuperview()
    }
    
    func setupProjectNameLabel() {
        projectNameView.addSubview(projectNameLabel)
        projectNameLabel.layoutFillSuperview(horizontalPadding: 16.0)
    }
    
    // MARK: - Setters
    
    func configure(_ headerData: ProjectDetailHeaderViewDataProtocol) {
        bannerImageView.set(projectName: headerData.projectName, bannerImage: headerData.bannerImage)
        projectNameLabel.text = headerData.projectName
    }
}

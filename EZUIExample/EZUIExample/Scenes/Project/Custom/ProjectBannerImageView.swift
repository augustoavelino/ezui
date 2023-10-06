//
//  ProjectBannerImageView.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 03/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class ProjectBannerImageView: EZView {
    
    enum BannerSize {
        case small, large
    }
    
    // MARK: Properties
    
    var projectName: String?
    var bannerImage: UIImage?
    
    // MARK: UI
    
    lazy var nameLabel = DSLabel(
        textAlignment: .center,
        textStyle: .title1
    )
    lazy var imageView = UIImageView()
    
    // MARK: - Life cycle
    
    init(bannerSize: BannerSize, projectName: String? = nil, bannerImage: UIImage? = nil) {
        super.init(frame: .zero)
        set(projectName: projectName, bannerImage: bannerImage)
        nameLabel.textStyle = .largeTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        clipsToBounds = true
        layout { $0.height == 0.6 * widthAnchor }
        setupNameLabel()
        setupImageView()
    }
    
    func setupNameLabel() {
        addSubview(nameLabel)
        nameLabel.layout {
            $0.top == safeAreaLayoutGuide.topAnchor
            $0.leading == leadingAnchor
            $0.trailing == trailingAnchor
            $0.bottom == safeAreaLayoutGuide.bottomAnchor
        }
    }
    
    func setupImageView() {
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.layoutFillSuperview()
    }
    
    // MARK: - Setters
    
    func set(projectName: String?, bannerImage: UIImage?) {
        self.projectName = projectName
        self.bannerImage = bannerImage
        updateContent()
    }
    
    func set(projectName: String?) {
        self.projectName = projectName
        updateContent()
    }
    
    func set(bannerImage: UIImage?) {
        self.bannerImage = bannerImage
        updateContent()
    }
    
    func updateContent() {
        if let bannerImage = bannerImage {
            imageView.tintColor = nil
            imageView.image = bannerImage
        } else if let projectName = projectName, !projectName.isEmpty {
            imageView.image = nil
            nameLabel.text = makeLabelText(forName: projectName)
        } else {
            imageView.tintColor = .systemFill
            imageView.image = UIImage(systemName: "photo.fill")
        }
        nameLabel.isHidden = imageView.image != nil
        imageView.isHidden = imageView.image == nil
    }
    
    func makeLabelText(forName name: String) -> String {
        let nameComponents = name.components(separatedBy: " ")
        if nameComponents.count > 1,
           let firstName = nameComponents.first?.uppercased(),
           let lastName = nameComponents.last?.uppercased() {
            return String(firstName[firstName.startIndex]) + String(lastName[lastName.startIndex])
        } else if let safeName = nameComponents.first,
                  !safeName.isEmpty {
            if safeName.count > 1 {
                var auxName = safeName
                let firstLetter = String(auxName.removeFirst()).uppercased()
                let secondLetter = String(auxName.removeFirst()).uppercased()
                return firstLetter + secondLetter
            } else {
                var auxName = safeName
                return String(auxName.removeFirst()).uppercased()
            }
        }
        return "P"
    }
}

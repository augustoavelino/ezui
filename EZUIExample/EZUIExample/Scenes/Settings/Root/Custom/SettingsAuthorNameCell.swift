//
//  SettingsAuthorNameCell.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 03/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class SettingsAuthorNameCellData: SettingsCellData {
    let authorName: String
    let isPrimary: Bool
    
    init(authorName: String, isPrimary: Bool) {
        self.authorName = authorName
        self.isPrimary = isPrimary
        super.init(text: authorName, secondaryText: nil)
    }
}

class SettingsAuthorNameCell: EZTableViewCell {
    
    // MARK: Setup
    
    override func setupUI() {
        accessoryView = UIImageView(image: UIImage(systemName: "square.and.pencil"))
    }
    
    // MARK: - Configure
    
    func configure(_ cellData: SettingsCellDataProtocol) {
        if #available(iOS 14.0, *) {
            configureForIOS14(cellData)
        } else {
            configureForEarlierIOS(cellData)
        }
    }
    
    @available(iOS 14.0, *)
    func configureForIOS14(_ cellData: SettingsCellDataProtocol) {
        var configuration = defaultContentConfiguration()
        if let cellData = cellData as? SettingsAuthorNameCellData {
            configuration.image = makeImage()
            configuration.text = cellData.text
            configuration.textProperties.color = cellData.isPrimary ? .label : .secondaryLabel
            configuration.secondaryText = cellData.secondaryText
        }
        contentConfiguration = configuration
    }
    
    func configureForEarlierIOS(_ cellData: SettingsCellDataProtocol) {
        guard let cellData = cellData as? SettingsAuthorNameCellData else { return }
        imageView?.image = makeImage()
        textLabel?.text = cellData.text
        textLabel?.textColor = cellData.isPrimary ? .label : .secondaryLabel
        if let secondaryText = cellData.secondaryText {
            detailTextLabel?.text = secondaryText
        }
    }
    
    func makeImage() -> UIImage? {
        return UIImage(systemName: "person.crop.circle")
    }
}

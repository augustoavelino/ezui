//
//  SettingsTintCell.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 19/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class SettingsTintCellData: SettingsCellData {
    let color: UIColor?
    
    init(color: UIColor?, text: String, secondaryText: String? = nil) {
        self.color = color
        super.init(text: text, secondaryText: secondaryText)
    }
}

class SettingsTintCell: EZTableViewCell {
    
    // MARK: State
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        accessoryType = selected ? .checkmark : .none
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
        if let cellData = cellData as? SettingsTintCellData {
            configuration.image = makeImage()
            configuration.imageProperties.tintColor = cellData.color
            configuration.text = cellData.text
            configuration.secondaryText = cellData.secondaryText
        }
        contentConfiguration = configuration
    }
    
    func configureForEarlierIOS(_ cellData: SettingsCellDataProtocol) {
        guard let cellData = cellData as? SettingsTintCellData else { return }
        imageView?.image = makeImage()
        imageView?.tintColor = cellData.color
        textLabel?.text = cellData.text
        if let secondaryText = cellData.secondaryText {
            detailTextLabel?.text = secondaryText
        }
    }
    
    func makeImage() -> UIImage? {
        return UIImage(systemName: "paintbrush.fill")
    }
}

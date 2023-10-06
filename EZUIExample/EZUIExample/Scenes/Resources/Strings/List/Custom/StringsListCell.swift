//
//  StringsListCell.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

struct StringsListCellData: StringsListCellDataProtocol {
    let name: String
    let dateCreatedText: String
    let dateUpdatedText: String
}

class StringsListCell: EZTableViewCell {
    override func setupUI() {
        accessoryType = .disclosureIndicator
    }
    
    // MARK: - Configure
    
    func configure(_ cellData: StringsListCellDataProtocol, tintColor: UIColor) {
        if #available(iOS 14.0, *) {
            configureForIOS14(cellData, tintColor: tintColor)
        } else {
            configureForEarlierIOS(cellData, tintColor: tintColor)
        }
    }
    
    @available(iOS 14.0, *)
    func configureForIOS14(_ cellData: StringsListCellDataProtocol, tintColor: UIColor) {
        var content = defaultContentConfiguration()
        content.secondaryTextProperties.color = .secondaryLabel
        content.textToSecondaryTextVerticalPadding = 8.0
        content.image = makeImage(tintColor: tintColor)
        content.text = cellData.name
        content.secondaryText = makeSecondaryText(
            dateCreatedText: cellData.dateCreatedText,
            dateUpdatedText: cellData.dateUpdatedText
        )
        contentConfiguration = content
    }
    
    func configureForEarlierIOS(_ cellData: StringsListCellDataProtocol, tintColor: UIColor) {
        imageView?.image = makeImage(tintColor: tintColor)
        textLabel?.text = cellData.name
        detailTextLabel?.textColor = .secondaryLabel
        detailTextLabel?.text = makeSecondaryText(
            dateCreatedText: cellData.dateCreatedText,
            dateUpdatedText: cellData.dateUpdatedText
        )
    }
    
    func makeImage(tintColor: UIColor) -> UIImage? {
        let image = UIImage(systemName: "doc.text.fill")
        if #available(iOS 15.0, *) {
            return image?.applyingSymbolConfiguration(.init(hierarchicalColor: tintColor))
        }
        return image
    }
    
    func makeSecondaryText(dateCreatedText: String, dateUpdatedText: String) -> String {
        return dateCreatedText + "\t   " + dateUpdatedText
    }
}

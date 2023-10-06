//
//  ColorPaletteListCell.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 12/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

struct ColorPaletteListCellData: ColorPaletteListCellDataProtocol {
    let name: String
    let dateCreatedText: String
    let dateUpdatedText: String
}

class ColorPaletteListCell: EZTableViewCell {
    override func setupUI() {
        accessoryType = .disclosureIndicator
    }
    
    // MARK: - Configure
    
    func configure(_ cellData: ColorPaletteListCellDataProtocol) {
        if #available(iOS 14.0, *) {
            configureForIOS14(cellData)
        } else {
            configureForEarlierIOS(cellData)
        }
    }
    
    @available(iOS 14.0, *)
    func configureForIOS14(_ cellData: ColorPaletteListCellDataProtocol) {
        var content = defaultContentConfiguration()
        content.secondaryTextProperties.color = .secondaryLabel
        content.textToSecondaryTextVerticalPadding = 8.0
        content.image = makeImage()
        content.text = cellData.name
        content.secondaryText = makeSecondaryText(
            dateCreatedText: cellData.dateCreatedText,
            dateUpdatedText: cellData.dateUpdatedText
        )
        contentConfiguration = content
    }
    
    func configureForEarlierIOS(_ cellData: ColorPaletteListCellDataProtocol) {
        imageView?.image = makeImage()
        textLabel?.text = cellData.name
        detailTextLabel?.textColor = .secondaryLabel
        detailTextLabel?.text = makeSecondaryText(
            dateCreatedText: cellData.dateCreatedText,
            dateUpdatedText: cellData.dateUpdatedText
        )
    }
    
    func makeImage() -> UIImage? {
        let image = UIImage(systemName: "paintpalette.fill")
        if #available(iOS 15.0, *) {
            return image?.applyingSymbolConfiguration(.preferringMulticolor())
        }
        return image
    }
    
    func makeSecondaryText(dateCreatedText: String, dateUpdatedText: String) -> String {
        return dateCreatedText + "\t   " + dateUpdatedText
    }
}

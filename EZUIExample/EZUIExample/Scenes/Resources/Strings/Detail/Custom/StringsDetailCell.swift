//
//  StringsDetailCell.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

struct StringsDetailCellData: StringsDetailCellDataProtocol {
    let key: String
    let value: String
}

class StringsDetailCell: EZTableViewCell {
    
    // MARK: - Configure
    
    func configure(_ cellData: StringsDetailCellDataProtocol, isExpanded: Bool = false) {
        if #available(iOS 14.0, *) {
            configureForIOS14(cellData, isExpanded: isExpanded)
        } else {
            configureForEarlierIOS(cellData, isExpanded: isExpanded)
        }
    }
    
    @available(iOS 14.0, *)
    func configureForIOS14(_ cellData: StringsDetailCellDataProtocol, isExpanded: Bool) {
        var content = defaultContentConfiguration()
        content.image = makeImage()
        content.text = cellData.key
        content.secondaryText = cellData.value
        content.textProperties.font = DSMonospacedFont.preferredFont(forTextStyle: .body)
        content.secondaryTextProperties.font = DSMonospacedFont.preferredFont(forTextStyle: .caption1)
        content.secondaryTextProperties.color = .secondaryLabel
        content.secondaryTextProperties.numberOfLines = isExpanded ? 0 : 2
        content.textToSecondaryTextVerticalPadding = 8.0
        contentConfiguration = content
    }
    
    func configureForEarlierIOS(_ cellData: StringsDetailCellDataProtocol, isExpanded: Bool) {
        imageView?.image = makeImage()
        textLabel?.text = cellData.key
        textLabel?.font = DSMonospacedFont.preferredFont(forTextStyle: .body)
        detailTextLabel?.text = cellData.value
        detailTextLabel?.font = DSMonospacedFont.preferredFont(forTextStyle: .caption1)
        detailTextLabel?.textColor = .secondaryLabel
        detailTextLabel?.numberOfLines = isExpanded ? 0 : 2
    }
    
    func makeImage() -> UIImage? {
        return UIImage(systemName: "text.quote")
    }
}

//
//  DSAuxiliaryLabel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 30/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

open class DSAuxiliaryLabel: UILabel {
    
    // MARK: Properties
    
    open var fontType: EZFont.Type
    
    open var textStyle: UIFont.TextStyle = .body {
        didSet { updateTextStyle() }
    }
    
    // MARK: - Life cycle
    
    public init(
        fontType: EZFont.Type = UIFont.self,
        text: String? = nil,
        textAlignment: NSTextAlignment = .natural,
        textStyle: UIFont.TextStyle = .body,
        textColor: UIColor? = .label,
        numberOfLines: Int = 1
    ) {
        self.fontType = fontType
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        self.textStyle = textStyle
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        updateTextStyle()
    }
    
    public override init(frame: CGRect) {
        self.fontType = UIFont.self
        super.init(frame: frame)
        updateTextStyle()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Display updates
    
    open func updateTextStyle() {
        font = fontType.preferredFont(forTextStyle: textStyle)
    }
}

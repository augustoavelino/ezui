//
//  EZTextField.swift
//  EZUI
//
//  Created by Augusto Avelino on 04/12/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZTextField<Font: EZFont>: UITextField {
    
    // MARK: Properties
    
    open var textStyle: UIFont.TextStyle = .body {
        didSet { updateTextStyle() }
    }
    
    // MARK: - Life cycle
    
    public init(
        text: String? = nil,
        placeholder: String? = nil,
        textAlignment: NSTextAlignment = .natural,
        textStyle: UIFont.TextStyle = .body,
        textColor: UIColor? = .label
    ) {
        super.init(frame: .zero)
        self.text = text
        self.placeholder = placeholder
        self.textAlignment = textAlignment
        self.textStyle = textStyle
        self.textColor = textColor
        updateTextStyle()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Display updates
    
    open func updateTextStyle() {
        font = Font.preferredFont(forTextStyle: textStyle)
    }
}

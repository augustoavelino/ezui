//
//  EZTextView.swift
//  EZUI
//
//  Created by Augusto Avelino on 28/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZTextView<Font: EZFont>: UITextView {
    
    // MARK: Properties
    
    open var textStyle: UIFont.TextStyle = .body {
        didSet { updateTextStyle() }
    }
    
    // MARK: - Life cycle
    
    public init(
        text: String? = nil,
        textAlignment: NSTextAlignment = .natural,
        textStyle: UIFont.TextStyle = .body,
        textColor: UIColor? = .label
    ) {
        super.init(frame: .zero, textContainer: nil)
        self.text = text
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

//
//  EZLabel.swift
//  EZUI
//
//  Created by Augusto Avelino on 07/08/22.
//  Copyright © 2022 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZLabel<Font: EZFont>: UILabel {
    
    // MARK: Properties
    
    open var textStyle: UIFont.TextStyle = .body {
        didSet { updateTextStyle() }
    }
    
    // MARK: - Life cycle
    
    public init(
        text: String? = nil,
        textAlignment: NSTextAlignment = .natural,
        textStyle: UIFont.TextStyle = .body,
        textColor: UIColor? = .label,
        numberOfLines: Int = 1
    ) {
        super.init(frame: .zero)
        self.text = text
        self.textAlignment = textAlignment
        self.textStyle = textStyle
        self.textColor = textColor
        self.numberOfLines = numberOfLines
        updateTextStyle()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        updateTextStyle()
    }
    
    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Display updates
    
    open func updateTextStyle() {
        font = Font.preferredFont(forTextStyle: textStyle)
    }
}

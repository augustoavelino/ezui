//
//  DSTextField.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 12/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class DSTextField: EZTextField<DSFont> {
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.leftViewRect(forBounds: bounds)
        return CGRect(
            x: rect.origin.x + 4.0,
            y: rect.origin.y,
            width: rect.width,
            height: rect.height
        )
    }
}

class DSLabeledTextField: EZView {
    
    // MARK: Properties
    
    var labelText: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    var topImage: UIImage? {
        get { topImageView.image }
        set { topImageView.image = newValue }
    }
    
    var text: String? {
        get { textField.text }
        set { textField.text = newValue }
    }
    
    var placeholder: String? {
        get { textField.placeholder }
        set { textField.placeholder = newValue }
    }
    
    var textAlignment: NSTextAlignment {
        get { textField.textAlignment }
        set { textField.textAlignment = newValue }
    }
    
    var textStyle: UIFont.TextStyle {
        get { textField.textStyle }
        set { textField.textStyle = newValue }
    }
    
    var textColor: UIColor? {
        get { textField.textColor }
        set { textField.textColor = newValue }
    }
    
    var autocapitalizationType: UITextAutocapitalizationType {
        get { textField.autocapitalizationType }
        set { textField.autocapitalizationType = newValue }
    }
    
    var autocorrectionType: UITextAutocorrectionType {
        get { textField.autocorrectionType }
        set { textField.autocorrectionType = newValue }
    }
    
    var returnKeyType: UIReturnKeyType {
        get { textField.returnKeyType }
        set { textField.returnKeyType = newValue }
    }
    
    var leftView: UIView? {
        get { textField.leftView }
        set { textField.leftView = newValue }
    }
    
    var leftViewMode: UITextField.ViewMode {
        get { textField.leftViewMode }
        set { textField.leftViewMode = newValue }
    }
    
    var rightView: UIView? {
        get { textField.rightView }
        set { textField.rightView = newValue }
    }
    
    var rightViewMode: UITextField.ViewMode {
        get { textField.rightViewMode }
        set { textField.rightViewMode = newValue }
    }
    
    var delegate: UITextFieldDelegate? {
        get { textField.delegate }
        set { textField.delegate = newValue }
    }
    
    // MARK: UI
    
    lazy var stackView = EZStackView(
        axis: .vertical,
        spacing: 8.0,
        arrangedSubviews: [topStackView, textField]
    )
    lazy var topStackView = EZStackView(
        spacing: 4.0,
        arrangedSubviews: [label, UIView(), topImageView]
    )
    lazy var label = DSLabel(
        textStyle: .callout, 
        textColor: .secondaryLabel
    )
    lazy var topImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layout {
            let imageSize: CGFloat = 20.0
            $0.width == imageSize
            $0.height == imageSize
        }
        return imageView
    }()
    lazy var textField: DSTextField = {
        let textField = DSTextField()
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    // MARK: - Life cycle
    
    init(
        labelText: String? = nil,
        topImage: UIImage? = nil,
        text: String? = nil,
        placeholder: String? = nil,
        textAlignment: NSTextAlignment = .left,
        textStyle: UIFont.TextStyle = .body,
        textColor: UIColor? = .label,
        autocapitalizationType: UITextAutocapitalizationType = .sentences,
        autocorrectionType: UITextAutocorrectionType = .default,
        returnKeyType: UIReturnKeyType = .default
    ) {
        super.init(frame: .zero)
        setupUI()
        self.labelText = labelText
        self.topImage = topImage
        self.text = text
        self.placeholder = placeholder
        self.textAlignment = textAlignment
        self.textStyle = textStyle
        self.textColor = textColor
        self.autocapitalizationType = autocapitalizationType
        self.autocorrectionType = autocorrectionType
        self.returnKeyType = returnKeyType
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        setupStackView()
    }
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.layoutFillSuperview()
    }
    
    // MARK: - Target
    
    func addTarget(_ target: Any?, action: Selector, for event: UIControl.Event) {
        textField.addTarget(target, action: action, for: event)
    }
}

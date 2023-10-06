//
//  ColorPickerValueInputView.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 30/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class ColorPickerValueInputView: DSSliderView {
    
    // MARK: Properties
    
    var isEditingText: Bool = false
    
    override var sliderTint: UIColor? {
        get { super.sliderTint }
        set {
            super.sliderTint = newValue
            textField.tintColor = newValue
        }
    }
    
    // MARK: UI
    
    override var topStackView: EZStackView {
        get { _topStackView }
        set { _topStackView = newValue }
    }
    private lazy var _topStackView = EZStackView(
        alignment: .lastBaseline,
        spacing: 4.0,
        arrangedSubviews: [titleLabel, valueLabel, UIView(), textField,]
    )
    
    override var titleLabel: DSLabel {
        get { _titleLabel }
        set { _titleLabel = newValue }
    }
    private lazy var _titleLabel = DSLabel(
        textStyle: .callout,
        textColor: .secondaryLabel
    )
    
    override var valueLabel: DSLabel {
        get { _valueLabel }
        set { _valueLabel = newValue }
    }
    private lazy var _valueLabel = DSLabel()
    
    private lazy var textField: DSTextField = {
        let textField = DSTextField(
            placeholder: "0",
            textAlignment: .right
        )
        textField.borderStyle = .roundedRect
        textField.autocapitalizationType = .none
        textField.autocorrectionType = .no
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldEditingChanged), for: .editingChanged)
        textField.layout { $0.width == 64.0 }
        textField.leftViewMode = .always
        textField.leftView = makeTextFieldLeftView()
        return textField
    }()
    
    // MARK: - Life cycle
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        updateTextField(hexValue: Int(value.rounded()))
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        super.setupUI()
        mainStackView.setCustomSpacing(12.0, after: topStackView)
    }
    
    // MARK: - Setters
    
    override func setValue(_ value: CGFloat, animated: Bool) {
        super.setValue(value, animated: animated)
        updateTextField(hexValue: Int(value))
    }

    private func setColorValue(_ hex: Int) {
        updateTextField(hexValue: hex)
        updateSliderView(hexValue: hex)
        delegate?.sliderView(self, didChangeValueTo: value)
    }

    // MARK: - Events
    
    @objc override func sliderDidChangeValue(_ sender: UISlider) {
        super.sliderDidChangeValue(sender)
        updateTextField(hexValue: Int(value.rounded()))
    }

    @objc private func textFieldEditingChanged(_ sender: UITextField) {
        textField.text = textField.text?.uppercased()
    }

    // MARK: - Display updates

    private func updateTextField(hexValue: Int) {
        textField.text = String(hexValue, radix: 16, uppercase: true)
    }

    private func updateSliderView(hexValue: Int, animated: Bool = false) {
        setValue(CGFloat(hexValue), animated: animated)
    }
    
    // MARK: - Building helpers
    
    private func makeTextFieldLeftView() -> UIView {
        let imageView = UIImageView(
            image: UIImage(systemName: "number")?.applyingSymbolConfiguration(.init(weight: .light))
        )
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}

// MARK: - UITextFieldDelegate

extension ColorPickerValueInputView: UITextFieldDelegate {
    fileprivate static let allowedCharacters = "0123456789abcdef"
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let isCharacterAllowed = ColorPickerValueInputView.allowedCharacters.contains(string.lowercased())
        let allowedChange = string.isEmpty || isCharacterAllowed
        guard allowedChange,
              let text = textField.text,
              let textRange = Range(range, in: text) else { return false }
        let newText = text.replacingCharacters(in: textRange, with: string)
        return newText.count <= 2
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isEditingText = true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateValueForText(textField.text)
        isEditingText = false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        updateValueForText(textField.text)
        isEditingText = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @discardableResult
    private func updateValueForText(_ text: String?) -> Bool {
        guard let text = text,
              text.count <= 2 else { return false }
        if let hexValue = Int(text, radix: 16) {
            setColorValue(hexValue)
        } else {
            setColorValue(0)
        }
        return true
    }
}

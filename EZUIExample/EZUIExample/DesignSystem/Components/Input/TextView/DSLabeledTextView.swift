//
//  DSLabeledTextView.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 28/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

protocol DSLabeledTextViewDelegate: AnyObject {
    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, willDismissEditMenuWith animator: UIEditMenuInteractionAnimating)
    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, willPresentEditMenuWith animator: UIEditMenuInteractionAnimating)
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu?
    func textViewDidBeginEditing(_ textView: UITextView)
    func textViewDidEndEditing(_ textView: UITextView)
    func textViewDidChange(_ textView: UITextView)
    func textViewDidChangeSelection(_ textView: UITextView)
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool
}

extension DSLabeledTextViewDelegate {
    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, willDismissEditMenuWith animator: UIEditMenuInteractionAnimating) {}
    
    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, willPresentEditMenuWith animator: UIEditMenuInteractionAnimating) {}
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {  true }
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool { true }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool { true }
    func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? { nil }
    
    func textViewDidBeginEditing(_ textView: UITextView) {}
    func textViewDidEndEditing(_ textView: UITextView) {}
    
    func textViewDidChange(_ textView: UITextView) {}
    func textViewDidChangeSelection(_ textView: UITextView) {}
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool { true }
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool { true }
}

class DSLabeledTextView: EZView {
    
    // MARK: Properties
    
    var fontType: EZFont.Type {
        get { textView.fontType }
        set { textView.fontType = newValue }
    }
    
    var labelText: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    var topImage: UIImage? {
        get { topImageView.image }
        set { topImageView.image = newValue }
    }
    
    var text: String? {
        get { textView.text }
        set { textView.text = newValue }
    }
    
    var placeholder: String? {
        get { textView.placeholder }
        set { textView.placeholder = newValue }
    }
    
    var textAlignment: NSTextAlignment {
        get { textView.textAlignment }
        set { textView.textAlignment = newValue }
    }
    
    var textStyle: UIFont.TextStyle {
        get { textView.textStyle }
        set { textView.textStyle = newValue }
    }
    
    var textColor: UIColor? {
        get { textView.textColor }
        set { textView.textColor = newValue }
    }
    
    var autocapitalizationType: UITextAutocapitalizationType {
        get { textView.autocapitalizationType }
        set { textView.autocapitalizationType = newValue }
    }
    
    var autocorrectionType: UITextAutocorrectionType {
        get { textView.autocorrectionType }
        set { textView.autocorrectionType = newValue }
    }
    
    var returnKeyType: UIReturnKeyType {
        get { textView.returnKeyType }
        set { textView.returnKeyType = newValue }
    }
    
    weak var delegate: DSLabeledTextViewDelegate?
    
    // MARK: UI
    
    lazy var stackView = EZStackView(
        axis: .vertical,
        spacing: 8.0,
        arrangedSubviews: [topStackView, textView]
    )
    lazy var topStackView = EZStackView(
        spacing: 4.0,
        arrangedSubviews: [label, UIView(), topImageView]
    )
    lazy var label = DSLabel(textStyle: .callout, textColor: .secondaryLabel)
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
    lazy var textView: DSPlaceholderTextView = {
        let textView = DSPlaceholderTextView()
        textView.dsDelegate = self
        return textView
    }()
    
    // MARK: - Life cycle
    
    init(
        fontType: EZFont.Type = DSFont.self,
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
        self.fontType = fontType
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
        setupTextView()
    }
    
    private func setupStackView() {
        addSubview(stackView)
        stackView.layoutFillSuperview()
    }
    
    private func setupTextView() {
        textView.contentInset.left = 8.0
        textView.backgroundColor = .dsColor(.background(.primary))
        textView.cornerRadius = 5.0
        textView.borderColor = UIColor.systemFill.cgColor
        textView.borderWidth = 0.5
    }
}

// MARK: - UITextViewDelegate

extension DSLabeledTextView: DSPlaceholderTextViewDelegate {
    @available(iOS 16.0, *)
    func textView(_ textView: DSPlaceholderTextView, willDismissEditMenuWith animator: UIEditMenuInteractionAnimating) {
        delegate?.textView(textView, willDismissEditMenuWith: animator)
    }
    
    @available(iOS 16.0, *)
    func textView(_ textView: DSPlaceholderTextView, willPresentEditMenuWith animator: UIEditMenuInteractionAnimating) {
        delegate?.textView(textView, willPresentEditMenuWith: animator)
    }
    
    func textView(_ textView: DSPlaceholderTextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return delegate?.textView(textView, shouldInteractWith: url, in: characterRange, interaction: interaction) ?? true
    }
    
    func textView(_ textView: DSPlaceholderTextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return delegate?.textView(textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }
    
    func textView(_ textView: DSPlaceholderTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return delegate?.textView(textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    func textView(_ textView: DSPlaceholderTextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        return delegate?.textView(textView, editMenuForTextIn: range, suggestedActions: suggestedActions)
    }
    
    func textViewDidBeginEditing(_ textView: DSPlaceholderTextView) {
        delegate?.textViewDidBeginEditing(textView)
    }
    
    func textViewDidEndEditing(_ textView: DSPlaceholderTextView) {
        delegate?.textViewDidEndEditing(textView)
    }
    
    func textViewDidChange(_ textView: DSPlaceholderTextView) {
        delegate?.textViewDidChange(textView)
    }
    
    func textViewDidChangeSelection(_ textView: DSPlaceholderTextView) {
        delegate?.textViewDidChangeSelection(textView)
    }
    
    func textViewShouldBeginEditing(_ textView: DSPlaceholderTextView) -> Bool {
        return delegate?.textViewShouldBeginEditing(textView) ?? true
    }
    
    func textViewShouldEndEditing(_ textView: DSPlaceholderTextView) -> Bool {
        return delegate?.textViewShouldEndEditing(textView) ?? true
    }
}

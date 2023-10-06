//
//  DSPlaceholderTextView.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 29/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

protocol DSPlaceholderTextViewDelegate: AnyObject {
    @available(iOS 16.0, *)
    func textView(_ textView: DSPlaceholderTextView, willDismissEditMenuWith animator: UIEditMenuInteractionAnimating)
    @available(iOS 16.0, *)
    func textView(_ textView: DSPlaceholderTextView, willPresentEditMenuWith animator: UIEditMenuInteractionAnimating)
    
    func textView(_ textView: DSPlaceholderTextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    func textView(_ textView: DSPlaceholderTextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    func textView(_ textView: DSPlaceholderTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    func textView(_ textView: DSPlaceholderTextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu?
    func textViewDidBeginEditing(_ textView: DSPlaceholderTextView)
    func textViewDidEndEditing(_ textView: DSPlaceholderTextView)
    func textViewDidChange(_ textView: DSPlaceholderTextView)
    func textViewDidChangeSelection(_ textView: DSPlaceholderTextView)
    func textViewShouldBeginEditing(_ textView: DSPlaceholderTextView) -> Bool
    func textViewShouldEndEditing(_ textView: DSPlaceholderTextView) -> Bool
}

extension DSPlaceholderTextViewDelegate {
    @available(iOS 16.0, *)
    func textView(_ textView: DSPlaceholderTextView, willDismissEditMenuWith animator: UIEditMenuInteractionAnimating) {}
    
    @available(iOS 16.0, *)
    func textView(_ textView: DSPlaceholderTextView, willPresentEditMenuWith animator: UIEditMenuInteractionAnimating) {}
    
    func textView(_ textView: DSPlaceholderTextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {  true }
    func textView(_ textView: DSPlaceholderTextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool { true }
    
    func textView(_ textView: DSPlaceholderTextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool { true }
    func textView(_ textView: DSPlaceholderTextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? { nil }
    
    func textViewDidBeginEditing(_ textView: DSPlaceholderTextView) {}
    func textViewDidEndEditing(_ textView: DSPlaceholderTextView) {}
    
    func textViewDidChange(_ textView: DSPlaceholderTextView) {}
    func textViewDidChangeSelection(_ textView: DSPlaceholderTextView) {}
    
    func textViewShouldBeginEditing(_ textView: DSPlaceholderTextView) -> Bool { true }
    func textViewShouldEndEditing(_ textView: DSPlaceholderTextView) -> Bool { true }
}

class DSPlaceholderTextView: DSTextView {
    
    // MARK: Properties
    
    weak var dsDelegate: DSPlaceholderTextViewDelegate?
    
    var fontType: EZFont.Type {
        didSet { placeholderLabel.fontType = fontType }
    }
    
    override var text: String! {
        get { super.text }
        set {
            super.text = newValue
            changePlaceholderVisibility(newValue)
        }
    }
    
    var placeholder: String? {
        get { placeholderLabel.text }
        set { placeholderLabel.text = newValue }
    }
    
    override var textStyle: UIFont.TextStyle {
        didSet { placeholderLabel.textStyle = textStyle }
    }
    
    // MARK: UI
    
    private lazy var placeholderLabel = DSAuxiliaryLabel(
        fontType: fontType,
        textStyle: textStyle,
        textColor: .placeholderText,
        numberOfLines: 0
    )
    
    // MARK: - Life cycle
    
    public init(
        fontType: EZFont.Type = DSFont.self,
        text: String? = nil,
        placeholder: String? = nil,
        textAlignment: NSTextAlignment = .natural,
        textStyle: UIFont.TextStyle = .body,
        textColor: UIColor? = .label
    ) {
        self.fontType = fontType
        super.init(text: text, textAlignment: textAlignment, textStyle: textStyle, textColor: textColor)
        self.placeholder = placeholder
        setupUI()
        updateTextStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        setupPlaceholderLabelWidthConstraints()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        delegate = self
        setupPlaceholderLabel()
    }
    
    private func setupPlaceholderLabel() {
        placeholderLabel.isUserInteractionEnabled = false
        addSubview(placeholderLabel)
        placeholderLabel.layout {
            $0.top == topAnchor + 8.0
            $0.leading == leadingAnchor + 4.0
            $0.height <= heightAnchor - 16.0
        }
    }
    
    private func setupPlaceholderLabelWidthConstraints() {
        placeholderLabel.layout {
            if let superview = superview {
                $0.width == superview.widthAnchor - 22.0
            } else {
                $0.width == UIScreen.main.bounds.width - 52.0
            }
        }
    }
    
    // MARK: - Events
    
    fileprivate func changePlaceholderVisibility(_ newText: String?) {
        guard let newText = newText else { return placeholderLabel.isHidden = false }
        return placeholderLabel.isHidden = !newText.isEmpty
    }
    
    override func updateTextStyle() {
        font = fontType.preferredFont(forTextStyle: textStyle)
    }
}

extension DSPlaceholderTextView: UITextViewDelegate {
    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, willDismissEditMenuWith animator: UIEditMenuInteractionAnimating) {
        dsDelegate?.textView(self, willDismissEditMenuWith: animator)
    }
    
    @available(iOS 16.0, *)
    func textView(_ textView: UITextView, willPresentEditMenuWith animator: UIEditMenuInteractionAnimating) {
        dsDelegate?.textView(self, willPresentEditMenuWith: animator)
    }
    
    func textView(_ textView: UITextView, shouldInteractWith url: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return dsDelegate?.textView(self, shouldInteractWith: url, in: characterRange, interaction: interaction) ?? true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return dsDelegate?.textView(self, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let shouldChange = dsDelegate?.textView(self, shouldChangeTextIn: range, replacementText: text) ?? true
        if let textRange = Range(range, in: textView.text) {
            let resultText = textView.text.replacingCharacters(in: textRange, with: text)
            self.changePlaceholderVisibility(resultText)
        }
        return shouldChange
    }
    
    func textView(_ textView: UITextView, editMenuForTextIn range: NSRange, suggestedActions: [UIMenuElement]) -> UIMenu? {
        return dsDelegate?.textView(self, editMenuForTextIn: range, suggestedActions: suggestedActions)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        dsDelegate?.textViewDidBeginEditing(self)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        dsDelegate?.textViewDidEndEditing(self)
    }
    
    func textViewDidChange(_ textView: UITextView) {
        dsDelegate?.textViewDidChange(self)
    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        dsDelegate?.textViewDidChangeSelection(self)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return dsDelegate?.textViewShouldBeginEditing(self) ?? true
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return dsDelegate?.textViewShouldEndEditing(self) ?? true
    }
}

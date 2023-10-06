//
//  StringsMakerViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 28/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

// MARK: - Base

class StringsMakerViewController: DSLegacyViewController {
    
    // MARK: Associated type
    
    fileprivate enum MakerType {
        case create, edit
    }
    
    // MARK: Properties
    
    weak var delegate: StringsMakerViewControllerDelegate?
    
    fileprivate var makerType: MakerType { .create }
    
    // MARK: UI
    
    lazy var stackView = EZStackView(
        axis: .vertical,
        spacing: 16.0,
        arrangedSubviews: [keyTextField, valueTextView, doneButton,]
    )
    lazy var keyTextField: DSLabeledTextField = {
        let textField = DSLabeledTextField(
            labelText: "Key",
            placeholder: "Ex: screenFooter"
        )
        textField.addTarget(self, action: #selector(didChangeKeyText), for: .valueChanged)
        textField.addTarget(self, action: #selector(didChangeKeyText), for: .allEditingEvents)
        return textField
    }()
    lazy var valueTextView: DSLabeledTextView = {
        let textView = DSLabeledTextView(
            labelText: "Value",
            placeholder: "Ex: Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc commodo ipsum ac erat ornare pellentesque ac sit amet elit. Aenean sit amet eros consequat, commodo ex nec, sodales neque."
        )
        textView.delegate = self
        return textView
    }()
    lazy var doneButton = makeDoneButton()
    
    // MARK: - Life cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.stringsMaker(self, willDisappearAnimated: animated)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        title = makerType == .create ? "New String" : "Edit String"
        view.backgroundColor = .systemBackground
        setupCloseButton()
        setupStackView()
    }
    
    private func setupCloseButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .close,
            target: self,
            action: #selector(didTapCloseButton)
        )
    }
    
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.layout {
            $0.top == view.safeAreaLayoutGuide.topAnchor + 16.0
            $0.leading == view.leadingAnchor + 16.0
            $0.trailing == view.trailingAnchor - 16.0
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor - 16.0
        }
    }
    
    // MARK: - Building helpers
    
    private func makeDoneButton() -> UIButton {
        var button: UIButton
        if #available(iOS 15.0, *) { button = makeDoneButtonForIOS15() }
        else { button = makeDoneButtonForEarlierIOS() }
        button.isEnabled = canCreateString(keyTextField.text, value: valueTextView.text)
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }
    
    @available(iOS 15.0, *)
    private func makeDoneButtonForIOS15() -> UIButton {
        var configuration = UIButton.Configuration.borderedProminent()
        configuration.imagePadding = 4.0
        configuration.buttonSize = .large
        configuration.image = makeDoneButtonImage()
        configuration.title = makeDoneButtonTitle()
        return UIButton(configuration: configuration)
    }
    
    private func makeDoneButtonForEarlierIOS() -> UIButton {
        let button = UIButton()
        button.setImage(makeDoneButtonImage(), for: .normal)
        button.setTitle(makeDoneButtonTitle(), for: .normal)
        return button
    }
    
    private func makeDoneButtonImage() -> UIImage? {
        switch makerType {
        case .create: return UIImage(systemName: "text.badge.plus")
        case .edit: return UIImage(systemName: "text.badge.checkmark")
        }
    }
    
    private func makeDoneButtonTitle() -> String {
        switch makerType {
        case .create: return "Add String"
        case .edit: return "Save String"
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapCloseButton(_ sender: UIBarButtonItem) {
        navigationController?.dismiss(animated: true)
    }
    
    @objc private func didTapDoneButton(_ sender: UIButton) {
        guard let key = keyTextField.text,
              let value = valueTextView.text else { return }
        delegate?.stringsMaker(self, didFinishWithKey: key, value: value)
        navigationController?.dismiss(animated: true)
    }
    
    @objc func didChangeKeyText(_ sender: UITextField) {
        doneButton.isEnabled = canCreateString(sender.text, value: valueTextView.text)
    }
}

// MARK: - DSLabeledTextViewDelegate

extension StringsMakerViewController: DSLabeledTextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let textRange = Range(range, in: textView.text) {
            let resultText = textView.text.replacingCharacters(in: textRange, with: text)
            doneButton.isEnabled = canCreateString(keyTextField.text, value: resultText)
        }
        return true
    }
    
    fileprivate func canCreateString(_ key: String?, value: String?) -> Bool {
        guard let key = key, let value = value else { return false }
        return !key.isEmpty && !value.isEmpty
    }
}

// MARK: - Creator

class StringsCreatorViewController: StringsMakerViewController {
    override fileprivate var makerType: MakerType { .create }
}

// MARK: - Editor

class StringsEditorViewController: StringsMakerViewController {
    override fileprivate var makerType: MakerType { .edit }
    
    init(key: String, value: String) {
        super.init(nibName: nil, bundle: nil)
        keyTextField.text = key
        valueTextView.text = value
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

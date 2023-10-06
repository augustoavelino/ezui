//
//  ColorPickerViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 12/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class ColorPickerViewController: DSLegacyViewController {
    
    // MARK: Associated type
    
    fileprivate enum PickerType {
        case create, edit
    }
    
    // MARK: Properties
    
    fileprivate var pickerType: PickerType { .create }
    
    weak var delegate: ColorPickerViewControllerDelegate?
    
    // MARK: UI
    
    let scrollView = UIScrollView()
    lazy var stackView = EZStackView(
        axis: .vertical,
        spacing: 16.0,
        arrangedSubviews: [colorView, textFieldsStackView, sliderSectionStackView, doneButton]
    )
    lazy var colorView = DSColorView()
    lazy var textFieldsStackView = EZStackView(
        spacing: 8.0,
        arrangedSubviews: [nameTextField, hexTextField,]
    )
    lazy var nameTextField: DSLabeledTextField = {
        let textField = DSLabeledTextField(
            labelText: "Name",
            placeholder: "Ex: accent",
            autocapitalizationType: .none,
            autocorrectionType: .no,
            returnKeyType: .done
        )
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldValueDidChange), for: .valueChanged)
        textField.addTarget(self, action: #selector(textFieldValueDidChange), for: .editingChanged)
        return textField
    }()
    lazy var hexTextField: DSLabeledTextField = {
        let textField = DSLabeledTextField(
            labelText: "Hex",
            placeholder: "9ABCDEFF",
            autocapitalizationType: .none,
            autocorrectionType: .no,
            returnKeyType: .done
        )
        textField.textAlignment = .right
        textField.leftViewMode = .always
        textField.leftView = makeHexTextFieldLeftView()
        textField.layout { $0.width == 136.0 }
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldValueDidChange), for: .valueChanged)
        textField.addTarget(self, action: #selector(textFieldValueDidChange), for: .editingChanged)
        return textField
    }()
    lazy var sliderSectionStackView = EZStackView(
        axis: .vertical,
        spacing: 8.0,
        arrangedSubviews: [sliderLabel, sliderBackgroundView,]
    )
    lazy var sliderLabel = DSLabel(
        text: "Values",
        textStyle: .callout,
        textColor: .secondaryLabel
    )
    lazy var sliderBackgroundView: UIView = {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .dsColor(.background(.primary))
        backgroundView.cornerRadius = 5.0
        backgroundView.borderColor = UIColor.systemFill.cgColor
        backgroundView.borderWidth = 0.5
        return backgroundView
    }()
    lazy var sliderStackView = EZStackView(
        axis: .vertical,
        spacing: 8.0,
        arrangedSubviews: [
            redInputView,
            DSSeparator(forOrientation: .vertical),
            greenInputView,
            DSSeparator(forOrientation: .vertical),
            blueInputView,
            DSSeparator(forOrientation: .vertical),
            alphaInputView,
        ]
    )
    lazy var redInputView = makeInputView(
        title: "Red:",
        sliderTint: .systemRed
    )
    lazy var greenInputView = makeInputView(
        title: "Green:",
        sliderTint: .systemGreen
    )
    lazy var blueInputView = makeInputView(
        title: "Blue:",
        sliderTint: .systemBlue
    )
    lazy var alphaInputView = makeInputView(
        title: "Opacity:",
        initialMultiplier: 1.0,
        sliderTint: .systemBrown
    )
    lazy var doneButton: UIButton = {
        let button = makeDoneButton()
        button.isEnabled = !(nameTextField.text ?? "").isEmpty
        button.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life cycle
    
    override func viewWillDisappear(_ animated: Bool) {
        delegate?.colorPicker(self, willDisappearAnimated: animated)
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        title = pickerType == .create ? "New Color" : "Edit Color"
        view.backgroundColor = .systemBackground
        setupCloseButton()
        setupScrollView()
        setupStackView()
        setupSliderStackView()
        updateColorView()
    }
    
    private func setupCloseButton() {
        navigationItem.rightBarButtonItem = makeSystemBarButton(
            .close, 
            action: #selector(didTapCloseButton)
        )
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.layoutFillSuperview()
    }
    
    private func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.layout {
            $0.top == scrollView.topAnchor + 16.0
            $0.bottom == scrollView.bottomAnchor - 16.0
            $0.leading == view.safeAreaLayoutGuide.leadingAnchor + 16.0
            $0.trailing == view.safeAreaLayoutGuide.trailingAnchor - 16.0
        }
    }
    
    private func setupSliderStackView() {
        sliderBackgroundView.addSubview(sliderStackView)
        sliderStackView.layoutFillSuperview(padding: 16.0)
    }
    
    private func updateColorView() {
        let color = generateColor()
        hexTextField.text = ColorFormatter(prefix: "").stringFromInt(rgba: Int64(color.rgbaInt()))
        colorView.color = color
    }
    
    fileprivate func generateColor() -> UIColor {
        return UIColor(
            red: redInputView.value / 255.0,
            green: greenInputView.value / 255.0,
            blue: blueInputView.value / 255.0,
            alpha: alphaInputView.value / 255.0
        )
    }
    
    private func makeSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .systemFill
        separator.layout { $0.height == 1.0 }
        return separator
    }
    
    // MARK: - Setters
    
    func set(hexValue: Int, animated: Bool = false) {
        let red = CGFloat(UIColor.getRedInt(fromRGBA: hexValue))
        let green = CGFloat(UIColor.getGreenInt(fromRGBA: hexValue))
        let blue = CGFloat(UIColor.getBlueInt(fromRGBA: hexValue))
        let alpha = CGFloat(UIColor.getAlphaInt(fromRGBA: hexValue))
        redInputView.setValue(red, animated: animated)
        greenInputView.setValue(green, animated: animated)
        blueInputView.setValue(blue, animated: animated)
        alphaInputView.setValue(alpha, animated: animated)
        colorView.color = generateColor()
        hexTextField.text = ColorFormatter(prefix: "").stringFromInt(rgba: Int64(hexValue))
    }
    
    // MARK: - Events
    
    @objc func textFieldValueDidChange(_ sender: UITextField) {
        if sender.isEqual(nameTextField.textField) {
            handleNameTextField(sender)
        } else if sender.isEqual(hexTextField.textField) {
            handleHexTextField(sender)
        }
    }
    
    private func handleNameTextField(_ sender: UITextField) {
        colorView.name = sender.text
        let safeText = sender.text ?? ""
        doneButton.isEnabled = !safeText.isEmpty
    }
    
    private func handleHexTextField(_ sender: UITextField) {
        sender.text = sender.text?.uppercased()
    }
    
    @objc func didTapCloseButton(_ sender: UIBarButtonItem) {
        delegate?.colorPickerDidCancel(self)
        navigationController?.dismiss(animated: true)
    }
    
    @objc func didTapDoneButton(_ sender: UIButton) {
        delegate?.colorPicker(self, didFinishWith: generateColor(), name: nameTextField.text ?? "")
        navigationController?.dismiss(animated: true)
    }
    
    // MARK: - Building helpers
    
    private func makeHexTextFieldLeftView() -> UIView {
        let imageView = UIImageView(
            image: makeTextFieldImage()
        )
        imageView.contentMode = .scaleAspectFit
        let gradient = makeGradientLayer(imageView.bounds)
        imageView.layer.insertSublayer(gradient, at: 0)
        return imageView
    }
    
    private func makeTextFieldImage() -> UIImage? {
        return UIImage(systemName: "number")?.applyingSymbolConfiguration(.init(weight: .light))
    }
    
    private func makeGradientLayer(_ imageViewBounds: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.frame = imageViewBounds
        gradient.colors = [
            UIColor.systemRed.cgColor,
            UIColor.systemGreen.cgColor,
            UIColor.systemBlue.cgColor,
            UIColor.systemBrown.cgColor,
        ]
        let mask = CALayer()
        mask.contents = makeTextFieldImage()?.cgImage
        mask.frame = gradient.bounds
        gradient.mask = mask
        return gradient
    }
    
    private func makeInputView(
        title: String,
        initialMultiplier: Float = 0.5,
        sliderTint: UIColor? = nil
    ) -> ColorPickerValueInputView {
        let inputView = ColorPickerValueInputView(
            title: title,
            maximumValue: 255.0,
            initialMultiplier: initialMultiplier,
            sliderTint: sliderTint
        )
        inputView.delegate = self
        return inputView
    }
    
    private func makeDoneButton() -> UIButton {
        var button: UIButton
        if #available(iOS 15.0, *) {
            button = makeDoneButtonForIOS15()
        } else {
            button = makeDoneButtonForEarlierIOS()
        }
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
        button.setTitle("Add Color", for: .normal)
        return button
    }
    
    private func makeDoneButtonImage() -> UIImage? {
        switch pickerType {
        case .create: return UIImage(systemName: "plus.app")
        case .edit: return UIImage(systemName: "checkmark.square")
        }
    }
    
    private func makeDoneButtonTitle() -> String {
        switch pickerType {
        case .create: return "Add Color"
        case .edit: return "Save Color"
        }
    }
}

// MARK: - DSSliderViewDelegate

extension ColorPickerViewController: DSSliderViewDelegate {
    func sliderView(_ sliderView: DSSliderView, didChangeValueTo value: CGFloat) {
        DispatchQueue.main.async {
            self.updateColorView()
        }
    }
}

// MARK: - UITextFieldDelegate

extension ColorPickerViewController: UITextFieldDelegate {
    fileprivate static let allowedCharacters = "0123456789abcdef"
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.isEqual(hexTextField.textField) else { return true }
        let isCharacterAllowed = ColorPickerViewController.allowedCharacters.contains(string.lowercased())
        let allowedChange = string.isEmpty || isCharacterAllowed
        guard allowedChange,
              let text = textField.text,
              let textRange = Range(range, in: text) else { return false }
        let newText = text.replacingCharacters(in: textRange, with: string)
        return newText.count <= 8
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard textField.isEqual(hexTextField.textField) else { return }
        updateValueForText(textField.text)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        guard textField.isEqual(hexTextField.textField) else { return }
        updateValueForText(textField.text)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Display updates

    private func updateTextField(hexValue: Int) {
        hexTextField.text = String(hexValue, radix: 16, uppercase: true)
    }
    
    @discardableResult
    private func updateValueForText(_ text: String?) -> Bool {
        guard let text = text,
              text.count <= 8 else { return false }
        if let hexValue = Int(text, radix: 16) {
            set(hexValue: hexValue)
        } else {
            set(hexValue: 0)
        }
        return true
    }
}

// MARK: - Creator

class ColorCreatorViewController: ColorPickerViewController {
    override fileprivate var pickerType: PickerType { .create }
}

// MARK: - Editor

class ColorEditorViewController: ColorPickerViewController {
    override fileprivate var pickerType: PickerType { .edit }
    
    init(name: String, hexValue: Int) {
        super.init(nibName: nil, bundle: nil)
        nameTextField.text = name
        set(hexValue: hexValue)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        colorView.name = nameTextField.text
        colorView.color = generateColor()
    }
}

//
//  DSSliderView.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 12/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

protocol DSSliderViewDelegate: AnyObject {
    func sliderView(_ sliderView: DSSliderView, didChangeValueTo value: CGFloat)
}

extension DSSliderViewDelegate {
    func sliderView(_ sliderView: DSSliderView, didChangeValueTo value: CGFloat) {}
}

class DSSliderView: EZView {
    
    // MARK: Properties
    
    weak var delegate: DSSliderViewDelegate?
    
    var title: String? {
        get { titleLabel.text }
        set { titleLabel.text = newValue }
    }
    var value: CGFloat { CGFloat(sliderValue) * maximumValue }
    var sliderValue: Float { slider.value }
    var minimumValue: CGFloat = 0.0
    var maximumValue: CGFloat = 100.0
    var valueFormat = "%.0f"
    
    var accessoryImage: UIImage? {
        get { accessoryImageView.image }
        set { accessoryImageView.image = newValue }
    }
    
    var sliderTint: UIColor? {
        get { slider.tintColor }
        set { slider.tintColor = newValue }
    }
    
    // MARK: UI
    
    lazy var mainStackView = EZStackView(
        axis: .vertical,
        spacing: 2.0,
        arrangedSubviews: [topStackView, slider, bottomStackView]
    )
    
    lazy var topStackView = EZStackView(
        alignment: .lastBaseline,
        spacing: 4.0,
        arrangedSubviews: [titleLabel, valueLabel, UIView(), accessoryImageView,]
    )
    lazy var titleLabel = DSLabel(
        textStyle: .callout,
        textColor: .secondaryLabel
    )
    lazy var valueLabel = DSLabel()
    lazy var accessoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layout {
            let imageSize: CGFloat = 22.0
            $0.width == imageSize
            $0.height == imageSize
        }
        return imageView
    }()
    
    lazy var bottomStackView = EZStackView(
        spacing: 8.0,
        arrangedSubviews: [minimumLabel, maximumLabel]
    )
    lazy var minimumLabel = DSLabel(
        textStyle: .caption2,
        textColor: .secondaryLabel
    )
    lazy var maximumLabel = DSLabel(
        textAlignment: .right,
        textStyle: .caption2,
        textColor: .secondaryLabel
    )
    
    lazy var slider: UISlider = {
        let slider = UISlider()
        slider.addTarget(self, action: #selector(sliderDidChangeValue), for: .valueChanged)
        return slider
    }()
    
    // MARK: - Life cycle
    
    init(
        title: String,
        valueFormat: String = "%.0f",
        minimumValue: CGFloat = 0.0,
        maximumValue: CGFloat = 100.0,
        initialMultiplier: Float = 0.5,
        sliderTint: UIColor? = nil,
        accessoryImage: UIImage? = nil
    ) {
        super.init(frame: .zero)
        self.minimumValue = minimumValue
        self.maximumValue = maximumValue
        self.sliderTint = sliderTint
        self.valueFormat = valueFormat
        self.accessoryImage = accessoryImage
        
        titleLabel.text = title
        minimumLabel.text = String(format: valueFormat, minimumValue)
        maximumLabel.text = String(format: valueFormat, maximumValue)
        slider.setValue(initialMultiplier, animated: false)
        reloadValueLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        addSubview(mainStackView)
        mainStackView.layoutFillSuperview()
    }
    
    // MARK: - Setters
    
    func setValue(_ value: CGFloat, animated: Bool) {
        let newSliderValue = max(minimumValue, min(value, maximumValue)) / maximumValue
        setSliderValue(Float(newSliderValue), animated: animated)
    }
    
    func setSliderValue(_ value: Float, animated: Bool) {
        slider.setValue(value, animated: animated)
        reloadValueLabel()
    }
    
    // MARK: - Events
    
    @objc func sliderDidChangeValue(_ sender: UISlider) {
        reloadValueLabel()
        delegate?.sliderView(self, didChangeValueTo: value)
    }
    
    private func reloadValueLabel() {
        valueLabel.text = String(format: valueFormat, value.rounded())
    }
}

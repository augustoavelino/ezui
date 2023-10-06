//
//  DSColorView.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 15/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class DSColorView: EZView {
    
    // MARK: Properties
    
    var name: String? {
        get { nameLabel.text }
        set { nameLabel.text = newValue }
    }
    
    var color: UIColor? {
        get { backgroundColor }
        set { setColor(newValue) }
    }
    
    // MARK: UI
    
    private lazy var colorMaskView = UIView()
    private lazy var colorView = UIView()
    private lazy var stackView = EZStackView(
        spacing: 4.0,
        arrangedSubviews: [nameLabel, hexLabel]
    )
    private lazy var nameLabel = DSLabel(textStyle: .callout)
    private lazy var hexLabel = DSLabel(
        textAlignment: .right,
        textStyle: .callout
    )
    
    // MARK: - Setup
    
    override func setupUI() {
        cornerRadius = 8.0
        setupMaskView()
        setupColorView()
        setupStackView()
    }
    
    private func setupMaskView() {
        colorMaskView.alpha = 0.25
        addSubview(colorMaskView)
        colorMaskView.layoutFillSuperview()
        guard let patternImage = UIImage(named: "pattern.check.atom") ?? UIImage(systemName: "dot.squareshape.split.2x2") else { return }
        colorMaskView.backgroundColor = UIColor(patternImage: patternImage, tintColor: .darkGray)
    }
    
    private func setupColorView() {
        addSubview(colorView)
        colorView.layoutFillSuperview()
    }
    
    private func setupStackView() {
        colorView.addSubview(stackView)
        stackView.layout {
            $0.top == colorView.topAnchor + 24.0
            $0.bottom == colorView.bottomAnchor - 8.0
            $0.leading == colorView.leadingAnchor + 8.0
            $0.trailing == colorView.trailingAnchor - 8.0
        }
    }
    
    private func setColor(_ newValue: UIColor?) {
        colorView.backgroundColor = newValue
        let newColor = newValue ?? .clear
        nameLabel.textColor = newColor.textColor()
        hexLabel.text = newColor.rgbaString(prefix: "#")
        hexLabel.textColor = newColor.secondaryTextColor()
    }
}

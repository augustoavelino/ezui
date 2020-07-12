//
//  IntroViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 30/03/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit
import EZUI

class IntroViewController: EZViewController {
    // MARK: UI
    let label = UILabel()
    let ezView = EZView()
    
    let colorMatrix: [[UIColor]] = [[.red, .green], [.blue, .yellow]]
    
    // MARK: - Setup
    override func setupUI() {
        setupColorViews()
        setupEZView()
        setupLabel()
    }
    
    private func setupColorViews() {
        let colorViewMatrix = colorMatrix.map { colors in
            return colors.map { color -> UIView in
                let colorView = UIView()
                colorView.backgroundColor = color
                return colorView
            }
        }
        let colorStacks = colorViewMatrix.map { colorViews -> UIStackView in
            let colorStack = UIStackView()
            colorStack.axis = .horizontal
            colorStack.alignment = .fill
            colorStack.distribution = .fillEqually
            colorStack.spacing = 0.0
            colorViews.forEach { colorStack.addArrangedSubview($0) }
            return colorStack
        }
        let mainColorStack = UIStackView()
        mainColorStack.axis = .vertical
        mainColorStack.alignment = .fill
        mainColorStack.distribution = .fillEqually
        mainColorStack.spacing = 0.0
        colorStacks.forEach { mainColorStack.addArrangedSubview($0) }
        view.addSubview(mainColorStack)
        mainColorStack.layout {
            $0.centerX == view.centerXAnchor
            $0.centerY == view.centerYAnchor
            $0.width == view.widthAnchor
            $0.height == view.heightAnchor
        }
    }
    
    private func setupEZView() {
        ezView.cornerRadius = 8.0
        ezView.visualEffect = .blur(style: .systemUltraThinMaterial)
        view.addSubview(ezView)
        ezView.layout {
            $0.centerX == view.centerXAnchor
            $0.centerY == view.centerYAnchor
        }
    }
    
    private func setupLabel() {
        label.text = "This is an example app to validate EZUI"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        ezView.addSubview(label)
        label.layoutFillSuperview(horizontalPadding: 16.0, verticalPadding: 8.0)
    }
}

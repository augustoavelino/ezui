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
    
    // MARK: - Setup
    override func setupUI() {
        setupLabel()
    }
    
    private func setupLabel() {
        label.text = "This is an example app to validate EZUI"
        label.numberOfLines = 0
        label.textAlignment = .center
        
        view.addSubview(label)
        label.layout {
            $0.leading == view.leadingAnchor + 32.0
            $0.trailing == view.trailingAnchor - 32.0
            $0.centerY == view.centerYAnchor
        }
    }
}

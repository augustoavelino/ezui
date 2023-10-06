//
//  SettingsTableFooterView.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 22/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class SettingsTableFooterView: EZView {
    
    // MARK: Properties
    
    var text: String? {
        get { label.text }
        set { label.text = newValue }
    }
    
    // MARK: UI
    
    lazy var label = DSLabel(
        textAlignment: .center,
        textStyle: .footnote,
        textColor: .secondaryLabel,
        numberOfLines: 0
    )
    
    // MARK: - Life cycle
    
    init(text: String?) {
        super.init(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 64.0))
        self.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        setupLabel()
    }
    
    func setupLabel() {
        addSubview(label)
        label.layoutFillSuperview()
    }
}

//
//  DSSeparator.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 24/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class DSSeparator: EZView {
    
    enum LayoutOrientation: Int {
        case horizontal, vertical
    }
    
    // MARK: Properties
    
    private var orientation: LayoutOrientation
    private var weight: CGFloat
    
    // MARK: - Life cycle
    
    init(
        forOrientation orientation: LayoutOrientation = .horizontal,
        color: UIColor = .systemFill,
        weight: CGFloat = 1.0
    ) {
        self.orientation = orientation
        self.weight = weight
        super.init(frame: .zero)
        backgroundColor = color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        setupOrientation()
    }
    
    private func setupOrientation() {
        layout {
            if orientation == .horizontal {
                $0.width == weight
            } else {
                $0.height == weight
            }
        }
    }
}

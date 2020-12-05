//
//  EZStackView.swift
//  EZUI
//
//  Created by Augusto Avelino on 05/12/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZStackView: UIStackView {
    public init(
        axis: NSLayoutConstraint.Axis = .horizontal,
        alignment: Alignment = .fill,
        distribution: Distribution = .fill,
        spacing: CGFloat = 0.0,
        arrangedSubviews: [UIView] = []
    ) {
        super.init(frame: .zero)
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
        for view in arrangedSubviews {
            addArrangedSubview(view)
        }
    }
    
    required public init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

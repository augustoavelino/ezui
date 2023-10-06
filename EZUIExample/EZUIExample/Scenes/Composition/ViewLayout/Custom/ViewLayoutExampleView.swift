//
//  ViewLayoutExampleView.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 12/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class ViewLayoutEzampleView: EZView {
    
    // MARK: Setup
    
    override func setupUI() {
        backgroundColor = UIColor.systemYellow.withAlphaComponent(0.25)
        setupBorder()
        setupCorners()
    }
    
    func setupBorder() {
        borderColor = UIColor.systemYellow.cgColor
        borderWidth = 1.5
    }
    
    func setupCorners() {
        setupCorner(.topLeft)
        setupCorner(.topRight)
        setupCorner(.bottomLeft)
        setupCorner(.bottomRight)
    }
    
    func setupCorner(_ corner: UIRectCorner) {
        let offset = borderWidth / 2.0
        let cornerView = makeCornerView(viewSide: 8.0)
        addSubview(cornerView)
        cornerView.layout {
            switch corner {
            case .topRight: layoutTopRightCorner($0, offset: offset)
            case .bottomLeft: layoutBottomLeftCorner($0, offset: offset)
            case .bottomRight: layoutBottomRightCorner($0, offset: offset)
            default: layoutTopLeftCorner($0, offset: offset)
            }
        }
    }
    
    func makeCornerView(viewSide: CGFloat) -> UIView {
        let view = UIView()
        view.backgroundColor = .systemYellow
        view.layout {
            $0.width == viewSide
            $0.height == viewSide
        }
        view.cornerRadius = viewSide / 2.0
        return view
    }
    
    func layoutTopLeftCorner(_ proxy: EZLayoutProxy, offset: CGFloat) {
        proxy.centerY == topAnchor + offset
        proxy.centerX == leadingAnchor + offset
    }
    
    func layoutTopRightCorner(_ proxy: EZLayoutProxy, offset: CGFloat) {
        proxy.centerY == topAnchor + offset
        proxy.centerX == trailingAnchor - offset
    }
    
    func layoutBottomLeftCorner(_ proxy: EZLayoutProxy, offset: CGFloat) {
        proxy.centerY == bottomAnchor - offset
        proxy.centerX == leadingAnchor + offset
    }
    
    func layoutBottomRightCorner(_ proxy: EZLayoutProxy, offset: CGFloat) {
        proxy.centerY == bottomAnchor - offset
        proxy.centerX == trailingAnchor - offset
    }
}

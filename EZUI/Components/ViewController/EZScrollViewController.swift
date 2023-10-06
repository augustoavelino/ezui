//
//  EZScrollViewController.swift
//  EZUI
//
//  Created by Augusto Avelino on 14/03/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZScrollViewController: EZViewController {
    // MARK: Nested types
    public enum ScrollAxis {
        case horizontal, vertical
    }
    
    // MARK: - Properties
    open var axis: ScrollAxis { .vertical }
    
    // MARK: UI
    public let scrollView = UIScrollView()
    public let contentView = UIView()
    
    // MARK: - Life cycle
    open override func viewDidLoad() {
        setupScrollView()
        setupContentView()
        super.viewDidLoad()
    }
    
    // MARK: - Setup
    open func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.layoutFillSuperview()
    }
    
    open func setupContentView() {
        scrollView.addSubview(contentView)
        contentView.layout {
            let isVertical = axis == .vertical
            $0.top == (isVertical ? scrollView.topAnchor : view.topAnchor)
            $0.leading == (isVertical ? view.leadingAnchor : scrollView.leadingAnchor)
            $0.trailing == (isVertical ? view.trailingAnchor : scrollView.trailingAnchor)
            $0.bottom == (isVertical ? scrollView.bottomAnchor : view.bottomAnchor)
        }
    }
}

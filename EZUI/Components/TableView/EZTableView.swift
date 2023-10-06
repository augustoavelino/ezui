//
//  EZTableView.swift
//  EZUI
//
//  Created by Augusto Avelino on 01/02/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZTableView: UITableView {
    
    // MARK: Life cycle
    
    public init(cellClass: EZTableViewCell.Type, headerFooterClasses: [EZTableViewHeaderFooterView.Type] = [], style: UITableView.Style = .plain, separatorStyle: UITableViewCell.SeparatorStyle = .none) {
        super.init(frame: .zero, style: style)
        self.separatorStyle = separatorStyle
        setupUI()
        register(cellClass)
        register(headerFooterClasses)
    }
    
    public init(cellClasses: [EZTableViewCell.Type], headerFooterClasses: [EZTableViewHeaderFooterView.Type] = [], style: UITableView.Style = .plain, separatorStyle: UITableViewCell.SeparatorStyle = .none) {
        super.init(frame: .zero, style: style)
        self.separatorStyle = separatorStyle
        setupUI()
        register(cellClasses)
        register(headerFooterClasses)
    }
    
    override public init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    open func setupUI() {
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = UITableView.automaticDimension
    }
    
    // MARK: Cell
    
    open func register(_ cellClass: EZTableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    open func register(_ cellClasses: [EZTableViewCell.Type]) {
        for cellClass in cellClasses {
            register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
        }
    }
    
    // MARK: Header | Footer
    
    open func register(_ viewClass: EZTableViewHeaderFooterView.Type) {
        register(viewClass, forHeaderFooterViewReuseIdentifier: viewClass.reuseIdentifier)
    }
    
    open func register(_ viewClasses: [EZTableViewHeaderFooterView.Type]) {
        for viewClass in viewClasses {
            register(viewClass, forHeaderFooterViewReuseIdentifier: viewClass.reuseIdentifier)
        }
    }
}

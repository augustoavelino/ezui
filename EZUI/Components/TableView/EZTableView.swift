//
//  EZTableView.swift
//  EZUI
//
//  Created by Augusto Avelino on 01/02/20.
//  Copyright © 2020 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZTableView: UITableView {
    public init(cellClass: EZTableViewCell.Type) {
        super.init(frame: .zero, style: .plain)
        commonInit()
        register(cellClass)
    }
    
    public init(cellClasses: [EZTableViewCell.Type]) {
        super.init(frame: .zero, style: .plain)
        commonInit()
        cellClasses.forEach { cellClass in
            register(cellClass)
        }
    }
    
    override public init(frame: CGRect, style: Style) {
        super.init(frame: frame, style: style)
        commonInit()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func commonInit() {
        backgroundColor = .clear
        separatorStyle = .none
        rowHeight = UITableView.automaticDimension
        estimatedRowHeight = UITableView.automaticDimension
    }
    
    open func register(_ cellClass: EZTableViewCell.Type) {
        register(cellClass, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
}

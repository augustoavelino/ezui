//
//  EZTableViewHeaderFooterView.swift
//  EZUI
//
//  Created by Augusto Avelino on 09/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZTableViewHeaderFooterView: UITableViewHeaderFooterView {
    
    // MARK: Reuse identifier
    
    open class var reuseIdentifier: String { "\(Self.self)" }
    
    // MARK: - Life cycle
    
    public override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    open func setupUI() {}
}

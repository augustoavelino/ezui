//
//  EZCollectionViewCell.swift
//  EZUI
//
//  Created by Augusto Avelino on 17/04/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZCollectionViewCell: UICollectionViewCell {
    
    // MARK: Reuse identifier
    
    open class var reuseIdentifier: String { "\(Self.self)" }
    
    // MARK: - Life cycle
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    open func setupUI() {}
}

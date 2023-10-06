//
//  EZCollectionView.swift
//  EZUI
//
//  Created by Augusto Avelino on 17/04/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

open class EZCollectionView: UICollectionView {
    // MARK: Life cycle
    public init(cellClass: EZCollectionViewCell.Type, collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        setupUI()
        register(cellClass)
    }
    
    public init(cellClasses: [EZCollectionViewCell.Type], collectionViewLayout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: collectionViewLayout)
        setupUI()
        cellClasses.forEach { cellClass in
            register(cellClass)
        }
    }
    
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    open func setupUI() {
        backgroundColor = .clear
    }
    
    open func register(_ cellClass: EZCollectionViewCell.Type) {
        register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
}

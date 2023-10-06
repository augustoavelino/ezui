//
//  DSViewModelDelegate.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 04/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

protocol DSViewModelDelegate: AnyObject {
    func displayActivityIndicator()
    func dismissAcitivityIndicators()
    func reloadData()
}

extension DSViewModelDelegate {
    func reloadData() {}
}

// MARK: Collection

protocol DSCollectionViewModelDelegate:
    AnyObject,
    DSViewModelDelegate,
    DSCollectionViewUpdater,
    UICollectionViewDataSource,
    UICollectionViewDelegate {}

// MARK: Table

protocol DSTableViewModelDelegate:
    AnyObject,
    DSViewModelDelegate,
    DSTableViewUpdater,
    UITableViewDataSource,
    UITableViewDelegate {}

//
//  DSCollectionViewUpdater.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 30/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

enum DSCollectionViewUpdate {
    case none
    case reloadData
    case insert([IndexPath])
    case delete([IndexPath])
    case reloadVisibleCells
    case reload([IndexPath])
    case reloadSections(IndexSet)
    case reconfigure([IndexPath])
    case deselect(IndexPath)
}

protocol DSCollectionViewUpdater: AnyObject {
    var isListEmpty: Bool { get }
    var emptyListView: DSEmptyListView? { get set }
    var collectionView: EZCollectionView { get }
    func performCollectionViewUpdate(_ update: DSCollectionViewUpdate)
    func setupCollectionViewComponents()
}

extension DSCollectionViewUpdater where Self: UIViewController {
    func setupCollectionViewComponents() {
        setupCollectionView()
        setupEmptyListView()
    }
    
    private func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.layoutFillSuperview()
    }
    
    private func setupEmptyListView() {
        let emptyView = DSEmptyListView()
        emptyListView = emptyView
        collectionView.addSubview(emptyView)
        emptyView.layout {
            $0.centerY == view.safeAreaLayoutGuide.centerYAnchor
            $0.leading == view.leadingAnchor + 16.0
            $0.trailing == view.trailingAnchor - 16.0
        }
    }
    
    func performCollectionViewUpdate(_ update: DSCollectionViewUpdate) {
        switch update {
        case .none: return
        case .reloadData: reloadCollectionViewData()
        case .insert(let indexPaths): insertCollectionItems(atIndexPaths: indexPaths)
        case .delete(let indexPaths): deleteCollectionItems(atIndexPaths: indexPaths)
        case .deselect(let indexPath): collectionView.deselectItem(at: indexPath, animated: false)
        case .reloadVisibleCells: reloadCollectionItemsAtVisibleIndexPaths()
        case .reloadSections(let sections): reloadCollectionSections(sections)
        case .reload(let indexPaths): reloadCollectionItems(atIndexPaths: indexPaths)
        case .reconfigure(let indexPaths):
            if #available(iOS 15.0, *) {
                reconfigureCollectionItems(atIndexPaths: indexPaths)
            } else {
                reloadCollectionItems(atIndexPaths: indexPaths)
            }
        }
    }
    
    private func reloadCollectionViewData() {
        performCollectionViewUpdates { collectionView in
            collectionView.reloadData()
            
        }
    }
    
    private func insertCollectionItems(atIndexPaths indexPaths: [IndexPath]) {
        performCollectionViewUpdates { collectionView in
            collectionView.insertItems(at: indexPaths)
        }
    }
    
    private func deleteCollectionItems(atIndexPaths indexPaths: [IndexPath]) {
        performCollectionViewUpdates { collectionView in
            collectionView.deleteItems(at: indexPaths)
        }
    }
    
    private func reloadCollectionItemsAtVisibleIndexPaths() {
        performCollectionViewUpdates { collectionView in
            collectionView.reloadItems(at: collectionView.indexPathsForVisibleItems)
        }
    }
    
    private func reloadCollectionSections(_ sections: IndexSet) {
        performCollectionViewUpdates { collectionView in
            collectionView.reloadSections(sections)
        }
    }
    
    private func reloadCollectionItems(atIndexPaths indexPaths: [IndexPath]) {
        performCollectionViewUpdates { collectionView in
            collectionView.reloadItems(at: indexPaths)
        }
    }
    
    @available(iOS 15.0, *)
    private func reconfigureCollectionItems(atIndexPaths indexPaths: [IndexPath]) {
        collectionView.reconfigureItems(at: indexPaths)
    }
    
    private func performCollectionViewUpdates(_ handler: @escaping (UICollectionView) -> Void) {
        DispatchQueue.main.async {
            handler(self.collectionView)
            self.updateCollectionEmptyState()
        }
    }
    
    private func updateCollectionEmptyState() {
        let notEmpty = !isListEmpty
        emptyListView?.isHidden = notEmpty
        collectionView.alwaysBounceHorizontal = notEmpty && collectionView.contentSize.width > collectionView.bounds.width
        collectionView.alwaysBounceVertical = notEmpty && collectionView.contentSize.height > 0.0
    }
}

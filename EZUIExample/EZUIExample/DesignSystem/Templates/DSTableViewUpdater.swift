//
//  DSTableViewUpdater.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 22/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

enum DSTableViewUpdate {
    case none
    case reloadData
    case move(at: IndexPath, to: IndexPath)
    case insert([IndexPath])
    case delete([IndexPath])
    case reloadVisibleCells
    case reload([IndexPath])
    case reconfigure([IndexPath])
    case select(IndexPath)
    case deselect(IndexPath)
}

protocol DSTableViewUpdater: AnyObject {
    var isListEmpty: Bool { get }
    var tableView: EZTableView { get }
    var emptyListView: DSEmptyListView? { get set }
    func performTableViewUpdate(_ update: DSTableViewUpdate, with animation: UITableView.RowAnimation)
    func setupTableViewComponents()
}

extension DSTableViewUpdater where Self: UIViewController {
    func setupTableViewComponents() {
        setupTableView()
        setupEmptyListView()
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.layoutFillSuperview()
    }
    
    private func setupEmptyListView() {
        let emptyView = DSEmptyListView()
        emptyListView = emptyView
        tableView.addSubview(emptyView)
        emptyView.layout {
            $0.centerY == view.safeAreaLayoutGuide.centerYAnchor
            $0.leading == view.leadingAnchor + 16.0
            $0.trailing == view.trailingAnchor - 16.0
        }
    }
    
    func performTableViewUpdate(_ update: DSTableViewUpdate, with animation: UITableView.RowAnimation = .top) {
        switch update {
        case .none: return
        case .reloadData: reloadTableViewData()
        case .move(let origin, let destination): moveRow(at: origin, to: destination)
        case .insert(let indexPaths): insertTableRows(atIndexPaths: indexPaths, with: animation)
        case .delete(let indexPaths): deleteTableRows(atIndexPaths: indexPaths, with: animation)
        case .select(let indexPath): selectTableRow(atIndexPath: indexPath, animated: animation != .none)
        case .deselect(let indexPath): deselectTableRow(atIndexPath: indexPath, animated: animation != .none)
        case .reloadVisibleCells: reloadTableRowsAtVisibleIndexPaths(with: animation)
        case .reload(let indexPaths): reloadTableRows(atIndexPaths: indexPaths, with: animation)
        case .reconfigure(let indexPaths):
            if #available(iOS 15.0, *) {
                reconfigureTableRows(atIndexPaths: indexPaths)
            } else {
                reloadTableRows(atIndexPaths: indexPaths, with: animation)
            }
        }
    }
    
    private func reloadTableViewData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateListEmptyState()
        }
    }
    
    private func moveRow(at origin: IndexPath, to destination: IndexPath) {
        performTableViewUpdates { tableView in
            tableView.moveRow(at: origin, to: destination)
        }
    }
    
    private func insertTableRows(atIndexPaths indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .top) {
        performTableViewUpdates { tableView in
            tableView.insertRows(at: indexPaths, with: animation)
        }
    }
    
    private func deleteTableRows(atIndexPaths indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .top) {
        performTableViewUpdates { tableView in
            tableView.deleteRows(at: indexPaths, with: animation)
        }
    }
    
    private func selectTableRow(atIndexPath indexPath: IndexPath, animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.selectRow(at: indexPath, animated: animated, scrollPosition: .none)
        }
    }
    
    private func deselectTableRow(atIndexPath indexPath: IndexPath, animated: Bool) {
        DispatchQueue.main.async {
            self.tableView.deselectRow(at: indexPath, animated: animated)
        }
    }
    
    private func reloadTableRowsAtVisibleIndexPaths(with animation: UITableView.RowAnimation = .top) {
        performTableViewUpdates { tableView in
            tableView.reloadRows(at: tableView.indexPathsForVisibleRows ?? [], with: animation)
        }
    }
    
    private func reloadTableRows(atIndexPaths indexPaths: [IndexPath], with animation: UITableView.RowAnimation = .top) {
        performTableViewUpdates { tableView in
            tableView.reloadRows(at: indexPaths, with: animation)
        }
    }
    
    @available(iOS 15.0, *)
    private func reconfigureTableRows(atIndexPaths indexPaths: [IndexPath]) {
        DispatchQueue.main.async {
            self.tableView.reconfigureRows(at: indexPaths)
        }
    }
    
    private func performTableViewUpdates(_ handler: @escaping (UITableView) -> Void) {
        DispatchQueue.main.async {
            self.tableView.beginUpdates()
            handler(self.tableView)
            self.tableView.endUpdates()
            self.updateListEmptyState()
        }
    }
    
    private func updateListEmptyState() {
        let notEmpty = !isListEmpty
        emptyListView?.isHidden = notEmpty
        tableView.alwaysBounceVertical = notEmpty
    }
}

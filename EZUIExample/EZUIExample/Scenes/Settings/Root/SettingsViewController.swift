//
//  SettingsViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 17/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class SettingsViewController<ViewModel: SettingsViewModelProtocol>: DSViewController<ViewModel>, DSTableViewModelDelegate {
    
    // MARK: UI
    
    var isListEmpty: Bool { false }
    var emptyListView: DSEmptyListView?
    
    lazy var tableView: EZTableView = {
        let tableView = EZTableView(
            cellClasses: [
                SettingsAuthorNameCell.self,
                SettingsTintCell.self,
            ],
            style: .insetGrouped,
            separatorStyle: .singleLine
        )
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Life cycle
    
    override init(viewModel: ViewModel) {
        super.init(viewModel: viewModel)
        navigationItem.largeTitleDisplayMode = .always
        title = .appString(.settings(.title))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableViewComponents()
        setupTableViewFooter()
    }
    
    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = makeBarButton(.sourceMenu, iconName: "list.bullet")
    }
    
    func setupTableViewFooter() {
        tableView.tableFooterView = SettingsTableFooterView(
            text: viewModel.textForTableFooter()
        )
    }
    
    func reloadData() {
        do {
            let result = try viewModel.fetchData().get()
            performTableViewUpdate(result)
            if let selectedIndexPath = try viewModel.selectedIndexPath().get() {
                performTableViewUpdate(.select(selectedIndexPath), with: .none)
            }
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellData = viewModel.dataForCell(atIndexPath: indexPath) else { return UITableViewCell() }
        if let authorCellData = cellData as? SettingsAuthorNameCellData {
            return tableViewAuthorCell(tableView, forRowAt: indexPath, cellData: authorCellData)
        } else if let tintCellData = cellData as? SettingsTintCellData {
            return tableViewTintCell(tableView, forRowAt: indexPath, cellData: tintCellData)
        } else {
            return UITableViewCell()
        }
    }
    
    func tableViewAuthorCell(_ tableView: UITableView, forRowAt indexPath: IndexPath, cellData: SettingsAuthorNameCellData) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsAuthorNameCell.reuseIdentifier,
            for: indexPath
        ) as? SettingsAuthorNameCell else { return UITableViewCell() }
        cell.configure(cellData)
        return cell
    }
    
    func tableViewTintCell(_ tableView: UITableView, forRowAt indexPath: IndexPath, cellData: SettingsTintCellData) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: SettingsTintCell.reuseIdentifier,
            for: indexPath
        ) as? SettingsTintCell else { return UITableViewCell() }
        cell.configure(cellData)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.title(forSection: section)
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let canSelect = viewModel.canSelectCell(atIndexPath: indexPath)
        if !canSelect { performActionForCell(atIndexPath: indexPath) }
        return canSelect
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard viewModel.canSelectCell(atIndexPath: indexPath) else { return }
        performActionForCell(atIndexPath: indexPath)
    }
    
    private func performActionForCell(atIndexPath indexPath: IndexPath) {
        viewModel.didSelectCell(atIndexPath: indexPath) { [weak self] result in
            guard let self = self else { return }
            do {
                let update = try result.get()
                self.performTableViewUpdate(update)
            } catch {
                self.presentErrorAlert(message: error.localizedDescription)
            }
        }
    }
}

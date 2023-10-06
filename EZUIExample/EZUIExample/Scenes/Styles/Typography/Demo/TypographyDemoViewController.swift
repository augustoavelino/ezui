//
//  TypographyDemoViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 11/08/22.
//  Copyright © 2022 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class TypographyDemoViewController<ViewModel: TypographyDemoViewModelProtocol>:
    DSViewController<ViewModel>,
    DSTableViewModelDelegate {
    
    // MARK: UI
    
    var isListEmpty: Bool { viewModel.isListEmpty() }
    var emptyListView: DSEmptyListView?
    
    lazy var tableView: EZTableView = {
        let tableView = EZTableView(cellClass: TypographyDemoCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        title = "Typography"
        view.backgroundColor = .systemBackground
        setupInfoButton()
        setupTableViewComponents()
    }
    
    func setupInfoButton() {
        navigationItem.rightBarButtonItem = makeBarButton(
            .info,
            iconName: "info.circle"
        )
    }
    
    // MARK: - Data
    
    func fetchData() {
        do {
            try viewModel.fetchData().get()
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellData = viewModel.dataForCell(atIndexPath: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: TypographyDemoCell.reuseIdentifier, for: indexPath) as? TypographyDemoCell else { return UITableViewCell() }
        cell.configure(cellData)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat { 0.0 }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? { UIView() }
}

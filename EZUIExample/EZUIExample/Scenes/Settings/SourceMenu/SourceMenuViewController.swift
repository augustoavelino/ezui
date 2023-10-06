//
//  SourceMenuViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 10/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

// TODO: Remover ou adaptar para ser uma biblioteca de todos os elementos criados (exceto projetos)
class SourceMenuViewController<ViewModel: SourceMenuViewModelProtocol>:
    DSViewController<ViewModel>,
    DSTableViewModelDelegate {
    
    // MARK: UI
    
    var isListEmpty: Bool { false }
    var emptyListView: DSEmptyListView?
    
    lazy var tableView: EZTableView = {
        let tableView = DSMenuTableView()
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    // MARK: - Life cycle
    
    override init(viewModel: ViewModel) {
        super.init(viewModel: viewModel)
        title = String.appString(.menu(.title))
        tabBarItem.image = UIImage(systemName: "archivebox.fill")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let window = (UIApplication.shared.delegate as? AppDelegate)?.window else { return }
        viewModel.updateTintColor(window.tintColor)
        performTableViewUpdate(.reloadData)
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        view.addSubview(tableView)
        tableView.layoutFillSuperview()
    }
    
    // MARK: - UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSection(section)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellData = viewModel.dataForCell(atIndexPath: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: DSMenuItemCell.reuseIdentifier, for: indexPath) as? DSMenuItemCell else { return UITableViewCell() }
        cell.configure(cellData)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCell(atIndexPath: indexPath)
    }
}

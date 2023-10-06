//
//  ColorPaletteDetailViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 10/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class ColorPaletteDetailViewController<ViewModel: ColorPaletteDetailViewModelProtocol>:
    DSViewController<ViewModel>,
    DSTableViewModelDelegate {
    
    // MARK: UI
    
    var isListEmpty: Bool { viewModel.isListEmpty() }
    var emptyListView: DSEmptyListView?
    
    lazy var tableView: EZTableView = {
        let tableView = EZTableView(cellClass: ColorPaletteDetailCell.self)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    weak var footnoteLabel: DSLabel?
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
        fetchData()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        setupNavigationBar()
//        setupToolbar()
        setupTableViewComponents()
    }
    
    func setupNavigationBar() {
        navigationItem.setRightBarButtonItems([
            makeAddBarButton(),
            makeBarButton(.renamePalette, iconName: "square.and.pencil.circle.fill"),
        ], animated: false)
    }
    
    func setupToolbar() {
        let countLabel = DSLabel(text: viewModel.footnote(), textStyle: .footnote)
        countLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        footnoteLabel = countLabel
        setToolbarItems([
            makeExportBarButton(),
            .safeFlexibleSpace(),
            UIBarButtonItem(customView: countLabel),
            .safeFlexibleSpace(),
            makeAddBarButton(),
        ], animated: false)
    }
    
    // MARK: - Data
    
    func reloadData() {
        title = viewModel.nameForPalette()
        footnoteLabel?.text = viewModel.footnote()
    }
    
    func fetchData() {
        do {
            try viewModel.fetchData().get()
            performTableViewUpdate(.reloadData)
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - Building helpers
    
    func makeAddBarButton() -> UIBarButtonItem {
        if #available(iOS 14.0, *) {
            return makeBarButton(
                .createColor,
                iconName: "plus.app.fill",
                menu: UIMenu(title: "Add", children: [
                    makeAction(.importColor, title: "Import", iconName: "square.and.arrow.down"),
                    makeAction(.createColor, title: "Create", iconName: "square.and.pencil"),
                ])
            )
        } else {
            return makeBarButton(.createColor, iconName: "plus.app.fill")
        }
    }
    
    func makeExportBarButton() -> UIBarButtonItem {
        if #available(iOS 14.0, *) {
            return makeBarButton(
                .exportPalette(type: .swift),
                iconName: "square.and.arrow.up",
                menu: UIMenu(title: "Export", children: [
                    makeAction(.exportPalette(type: .png), title: "PNG", iconName: "photo"),
                    makeAction(.exportPalette(type: .svg), title: "SVG", iconName: "icon.svg"),
                    makeAction(.exportPalette(type: .json), title: "JSON", iconName: "ellipsis.curlybraces"),
                    makeAction(.exportPalette(type: .swift), title: "Swift", iconName: "swift"),
                ])
            )
        } else {
            return makeBarButton(.exportPalette(type: .swift), iconName: "square.and.arrow.up")
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
        guard let cellData = viewModel.dataForCell(atIndexPath: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: ColorPaletteDetailCell.reuseIdentifier, for: indexPath) as? ColorPaletteDetailCell else { return UITableViewCell() }
        cell.configure(cellData)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            makeContextualAction(
                .editColor(indexPath: indexPath),
                iconName: "square.and.pencil",
                backgroundColor: view.tintColor
            ),
        ])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            makeContextualAction(
                .deleteColor(indexPath: indexPath),
                style: .destructive,
                iconName: "trash"
            )
        ])
    }
}

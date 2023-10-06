//
//  ColorPaletteListViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 12/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class ColorPaletteListViewController<ViewModel: ColorPaletteListViewModelProtocol>:
    DSViewController<ViewModel>,
    DSTableViewModelDelegate {
    
    // MARK: UI
    
    var isListEmpty: Bool { viewModel.isListEmpty() }
    var emptyListView: DSEmptyListView?

    lazy var tableView: EZTableView = {
        let tableView = EZTableView(
            cellClass: ColorPaletteListCell.self,
            separatorStyle: .singleLine
        )
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    weak var optionsButton: UIBarButtonItem?
    weak var footnoteLabel: DSLabel?
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.largeTitleDisplayMode = .always
        fetchData()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        title = "Color Palettes"
        view.backgroundColor = .systemBackground
        setupNavigationBarButtons()
        setupTableViewComponents()
    }
    
    func setupNavigationBarButtons() {
        let optionsButton = makeOptionsButton()
        let createButton = makeBarButton(.createPalette, iconName: "plus")
        navigationItem.rightBarButtonItems = [createButton, optionsButton]
    }
    
//    func setupToolbar() {
//        let countLabel = DSLabel(text: viewModel.footnote(), textStyle: .footnote)
//        countLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//        footnoteLabel = countLabel
//        setToolbarItems([
//            .safeFlexibleSpace(),
//            UIBarButtonItem(customView: countLabel),
//            .safeFlexibleSpace(),
//            makeBarButton(.createPalette, iconName: "plus.app.fill"),
//        ], animated: false)
//    }
    
    // MARK: - Data
    
    func reloadData() {
        footnoteLabel?.text = viewModel.footnote()
    }
    
    func fetchData() {
        displayActivityIndicator()
        do {
            try viewModel.fetchData().get()
            dismissAcitivityIndicators()
        } catch {
            dismissAcitivityIndicators()
            presentErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - Building helpers
    
    func makeOptionsButton() -> UIBarButtonItem {
        let actionType = ColorPaletteListAction.options
        let iconName = "ellipsis.circle"
        if #available(iOS 14.0, *) {
            let barButton = makeBarButton(iconName: iconName, menu: makeSortMenu())
            optionsButton = barButton
            return barButton
        } else {
            return makeBarButton(actionType, iconName: iconName)
        }
    }
    
    func makeSortMenu() -> UIMenu {
        return makeMenu(
            title: "Sort By",
            subtitle: "Default (Date Updated)",
            image: UIImage(systemName: "arrow.up.arrow.down"),
            childrenBuilder: { [weak self] menu in
                guard let self = self else { return [] }
                return [
                    self.makeSortTypeMenu(),
                    self.makeSortOrderMenu(),
                ]
            }
        )
    }
    
    func makeSortTypeMenu() -> UIMenu {
        let currentSortType = viewModel.currentSortType()
        return UIMenu(
            options: .displayInline,
            children:  [
                makeSortTypeAction(.default, isOn: currentSortType == .default, title: "Default (Date Updated)"),
                makeSortTypeAction(.dateUpdated, isOn: currentSortType == .dateUpdated, title: "Date Updated"),
                makeSortTypeAction(.dateCreated, isOn: currentSortType == .dateCreated, title: "Date Created"),
                makeSortTypeAction(.name, isOn: currentSortType == .name, title: "Name"),
            ]
        )
    }
    
    func makeSortOrderMenu() -> UIMenu {
        let currentSortOrder = viewModel.currentSortOrder()
        return UIMenu(
            options: .displayInline,
            children:  [
                makeSortOrderAction(.ascending, isOn: currentSortOrder == .ascending, title: "Ascending"),
                makeSortOrderAction(.descending, isOn: currentSortOrder == .descending, title: "Descending"),
            ]
        )
    }
    
    func makeSortTypeAction(_ sortType: ColorPaletteListSortType, isOn: Bool, title: String) -> UIAction {
        return makeAction(.sortType(sortType), title: title, state: isOn ? .on : .off) { [weak self] _ in
            guard let self = self else { return }
            if #available(iOS 14.0, *) {
                self.optionsButton?.menu = makeSortMenu()
            }
        }
    }
    
    func makeSortOrderAction(_ sortOrder: ColorPaletteListSortOrder, isOn: Bool, title: String) -> UIAction {
        return makeAction(.sortOrder(sortOrder), title: title, state: isOn ? .on : .off) { [weak self] _ in
            guard let self = self else { return }
            if #available(iOS 14.0, *) {
                self.optionsButton?.menu = makeSortMenu()
            }
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
              let cell = tableView.dequeueReusableCell(withIdentifier: ColorPaletteListCell.reuseIdentifier, for: indexPath) as? ColorPaletteListCell else { return UITableViewCell() }
        cell.configure(cellData)
        return cell
    }

    // MARK: - UITableViewDelegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCell(atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            makeContextualAction(
                .renamePalette(indexPath: indexPath),
                iconName: "square.and.pencil.circle",
                backgroundColor: view.tintColor
            ),
        ])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return UISwipeActionsConfiguration(actions: [
            makeContextualAction(
                .deletePalette(indexPath: indexPath),
                style: .destructive,
                iconName: "trash"
            ),
        ])
    }
}

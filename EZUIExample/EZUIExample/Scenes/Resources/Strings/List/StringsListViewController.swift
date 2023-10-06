//
//  StringsListViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class StringsListViewController<ViewModel: StringsListViewModelProtocol>: DSViewController<ViewModel>, DSTableViewModelDelegate {
    enum State {
        case normal, creating, renaming
    }
    
    // MARK: Properties
    
    var state: State = .normal
    var isListEmpty: Bool { viewModel.isListEmpty() }
    
    // MARK: UI
    
    var emptyListView: DSEmptyListView?
    lazy var tableView: EZTableView = {
        let tableView = EZTableView(
            cellClass: StringsListCell.self,
            separatorStyle: .singleLine
        )
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        return tableView
    }()
    
    weak var createAction: UIAlertAction?
    weak var renameAction: UIAlertAction?
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupTableViewComponents()
    }
    
    func setupNavigationBar() {
        title = "Strings Files"
        navigationItem.largeTitleDisplayMode = .always
        if #available(iOS 14.0, *) {
            navigationItem.backButtonDisplayMode = .minimal
        }
        navigationItem.rightBarButtonItems = [
            makeCreateButton(),
            makeOptionsButton(),
        ]
    }
    
    func makeOptionsButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapOptionsBarButton)
        )
    }
    
    func makeCreateButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil"),
            style: .plain,
            target: self,
            action: #selector(didTapCreateBarButton)
        )
    }
    
    // MARK: - Actions
    
    @objc func didTapOptionsBarButton(_ sender: UIBarButtonItem) {
        // TODO: Add implementation
        print("DID TAP OPTIONS")
    }
    
    @objc func didTapCreateBarButton(_ sender: UIBarButtonItem) {
        presentCreateAlert()
    }
    
    func presentCreateAlert() {
        guard state == .normal else { return }
        state = .creating
        presentAlert(
            title: "New Strings File",
            message: "Choose a name", configurationHandler: { [weak self] alert in
                guard let self = self else { return }
                self.configureCreateAlert(alert)
            }
        )
    }
    
    func configureCreateAlert(_ alert: UIAlertController) {
        addAlertCancelAction(alert)
        addAlertTextField(alert, placeholder: "Ex: ProjectNameString") { [weak self] alertCapture, textField in
            guard let self = self else { return }
            self.addAlertCreateAction(alertCapture, textField: textField)
        }
    }
    
    func presentRenameAlert(for indexPath: IndexPath, currentName: String) {
        guard state != .renaming else { return }
        state = .renaming
        presentAlert(
            title: "Rename Strings File",
            message: "Choose a new name", configurationHandler: { [weak self] alert in
                guard let self = self else { return }
                self.configureRenameAlert(alert, indexPath: indexPath, currentName: currentName)
            }
        )
    }
    
    func configureRenameAlert(_ alert: UIAlertController, indexPath: IndexPath, currentName: String) {
        addAlertCancelAction(alert)
        addAlertTextField(alert, text: currentName, placeholder: "Current: " + currentName) { [weak self] alertCapture, textField in
            guard let self = self else { return }
            self.addAlertRenameAction(alertCapture, textField: textField, indexPath: indexPath)
        }
    }
    
    func addAlertTextField(
        _ alert: UIAlertController,
        text: String? = nil,
        placeholder: String? = nil,
        completion: @escaping (UIAlertController, UITextField) -> Void
    ) {
        alert.addTextField { [weak self] textField in
            guard let self = self else { return }
            textField.text = text
            textField.placeholder = placeholder
            textField.clearButtonMode = .always
            textField.addTarget(self, action: #selector(textFieldDidUpdateText), for: .valueChanged)
            textField.addTarget(self, action: #selector(textFieldDidUpdateText), for: .editingChanged)
            completion(alert, textField)
        }
    }
    
    func addAlertCancelAction(_ alert: UIAlertController) {
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak self] _ in
            guard let self = self else { return }
            self.state = .normal
        })
    }
    
    func addAlertCreateAction(_ alert: UIAlertController, textField: UITextField) {
        let createAction = UIAlertAction(title: "Create", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.createStringsFile(named: textField.text)
        }
        createAction.isEnabled = false
        alert.addAction(createAction)
        self.createAction = createAction
    }
    
    func addAlertRenameAction(_ alert: UIAlertController, textField: UITextField, indexPath: IndexPath) {
        let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.renameStringsFile(atIndexPath: indexPath, newName: textField.text)
        }
        renameAction.isEnabled = false
        alert.addAction(renameAction)
        self.renameAction = renameAction
    }
    
    // MARK: - Events
    
    @objc func textFieldDidUpdateText(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if state == .creating, let createAction = createAction {
            createAction.isEnabled = !text.isEmpty
        } else if state == .renaming, let renameAction = renameAction {
            renameAction.isEnabled = !text.isEmpty
        }
    }
    
    // MARK: - Data
    
    func fetchData() {
        displayActivityIndicator()
        do {
            try viewModel.fetchData().get()
            dismissAcitivityIndicators()
            performTableViewUpdate(.reloadData)
        } catch {
            dismissAcitivityIndicators()
            presentErrorAlert(message: error.localizedDescription)
        }
    }
    
    func createStringsFile(named paletteName: String?) {
        do {
            try viewModel.createStringsFile(name: paletteName).get()
            state = .normal
        } catch {
            presentErrorAlert(message: error.localizedDescription)
            state = .normal
        }
    }
    
    func renameStringsFile(atIndexPath indexPath: IndexPath, newName paletteName: String?) {
        do {
            try viewModel.renameStringsFile(atIndexPath: indexPath, newName: paletteName).get()
            state = .normal
            DispatchQueue.main.async {
                if #available(iOS 15.0, *) {
                    self.tableView.reconfigureRows(at: self.tableView.indexPathsForVisibleRows ?? [])
                } else {
                    self.tableView.reloadRows(at: [indexPath], with: .automatic)
                }
            }
        } catch {
            presentErrorAlert(message: error.localizedDescription)
            state = .normal
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
              let cell = tableView.dequeueReusableCell(
                withIdentifier: StringsListCell.reuseIdentifier,
                for: indexPath
              ) as? StringsListCell else { return UITableViewCell() }
        cell.configure(cellData, tintColor: view.tintColor)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCell(atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let renameAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            guard let self = self, let cellData = self.viewModel.dataForCell(atIndexPath: indexPath) else { return }
            self.tableView.setEditing(false, animated: true)
            self.presentRenameAlert(for: indexPath, currentName: cellData.name)
        }
        renameAction.backgroundColor = view.tintColor
        renameAction.image = UIImage(systemName: "square.and.pencil.circle")?.applyingSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 24.0))
        return UISwipeActionsConfiguration(actions: [renameAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self = self else { return }
            self.deleteItem(atIndexPath: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func deleteItem(atIndexPath indexPath: IndexPath) {
        do {
            try viewModel.deleteStringsFile(atIndexPath: indexPath).get()
            performTableViewUpdate(.delete([indexPath]))
            if #available(iOS 15.0, *) {
                performTableViewUpdate(.reconfigure(tableView.indexPathsForVisibleRows ?? []), with: .none)
            }
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
}

//
//  StringsDetailViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class StringsDetailViewController<ViewModel: StringsDetailViewModelProtocol>: DSViewController<ViewModel>, DSTableViewModelDelegate {
    
    // MARK: UI
    
    var isListEmpty: Bool { viewModel.isListEmpty() }
    var emptyListView: DSEmptyListView?
    
    lazy var tableView: EZTableView = {
        let tableView = EZTableView(
            cellClass: StringsDetailCell.self,
            separatorStyle: .singleLine
        )
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    weak var renameAction: UIAlertAction?
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadData()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        setupNavigationBar()
        setupTableViewComponents()
    }
    
    func setupNavigationBar() {
        title = viewModel.paletteName()
        navigationItem.setRightBarButtonItems([
            makeButton(.add),
            makeButton(.export),
            makeButton(.rename),
            .safeFlexibleSpace(),
        ], animated: false)
    }
    
    // MARK: - Menu actions
    
    func didTapExportStringsAction() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileURL = try self.viewModel.didTapExportStringsButton().get()
                self.presentExportController([fileURL])
            } catch {
                self.presentErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func didTapExportSwiftAction() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileURL = try self.viewModel.didTapExportSwiftButton().get()
                self.presentExportController([fileURL])
            } catch {
                self.presentErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    func didTapExportJSONAction() {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let fileURL = try self.viewModel.didTapExportJSONButton().get()
                self.presentExportController([fileURL])
            } catch {
                self.presentErrorAlert(message: error.localizedDescription)
            }
        }
    }
    
    // MARK: - Button actions
    
    @objc func didTapExportButton(_ sender: UIBarButtonItem?) {
        didTapExportStringsAction()
    }
    
    @objc func didTapAddButton(_ sender: UIBarButtonItem) {
        let stringsMaker = StringsCreatorViewController()
        stringsMaker.delegate = self
        present(UINavigationController(rootViewController: stringsMaker), animated: true)
    }
    
    @objc func didTapRenameButton(_ sender: UIBarButtonItem) {
        presentRenameAlert(currentName: viewModel.paletteName())
    }
    
    @objc func didTapInfoButton(_ sender: UIBarButtonItem) {
        presentInfoController()
    }
    
    func reloadData() {
        do {
            try viewModel.fetchData().get()
            performTableViewUpdate(.reloadData)
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - Presenting
    
    func presentEditController(key: String, value: String) {
        let editController = StringsEditorViewController(key: key, value: value)
        editController.delegate = self
        present(UINavigationController(rootViewController: editController), animated: true)
    }
    
    func presentExportController(_ items: [Any]) {
        DispatchQueue.main.async {
            let activityController = UIActivityViewController(
                activityItems: items,
                applicationActivities: nil
            )
            self.present(activityController, animated: true)
        }
    }
    
    func presentRenameAlert(currentName: String) {
        let alert = UIAlertController(
            title: "Rename Strings File",
            message: "Choose a new name",
            preferredStyle: .alert
        )
        addAlertCancelAction(alert)
        addAlertTextField(alert, text: currentName, placeholder: "Current: " + currentName) { [weak self] alertCapture, textField in
            guard let self = self else { return }
            self.addAlertRenameAction(alert, textField: textField)
        }
        present(alert, animated: true)
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
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
    }
    
    func addAlertRenameAction(_ alert: UIAlertController, textField: UITextField) {
        let renameAction = UIAlertAction(title: "Rename", style: .default) { [weak self] _ in
            guard let self = self else { return }
            self.renameStringsFile(newName: textField.text)
        }
        renameAction.isEnabled = false
        alert.addAction(renameAction)
        self.renameAction = renameAction
    }
    
    func presentInfoController() {
        
    }
    
    // MARK: - Events
    
    @objc func textFieldDidUpdateText(_ textField: UITextField) {
        guard let renameAction = renameAction else { return }
        renameAction.isEnabled = viewModel.canRenameStringsFile(textField.text)
    }
    
    func renameStringsFile(newName fileName: String?) {
        do {
            try viewModel.renameStringsFile(fileName).get()
            title = viewModel.paletteName()
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
        guard let cellData = viewModel.dataForCell(atIndexPath: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: StringsDetailCell.reuseIdentifier, for: indexPath) as? StringsDetailCell else { return UITableViewCell() }
        cell.configure(cellData, isExpanded: viewModel.isCellExpanded(atIndexPath: indexPath))
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            let update = try viewModel.didSelectCell(atIndexPath: indexPath).get()
            performTableViewUpdate(update, with: .fade)
        } catch {
            print("Error: \(error)")
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: nil) { [weak self] _, _, completion in
            guard let self = self else { return completion(false) }
            tableView.setEditing(false, animated: true)
            self.editItem(atIndexPath: indexPath)
        }
        editAction.backgroundColor = view.tintColor
        editAction.image = UIImage(systemName: "square.and.pencil")
        return UISwipeActionsConfiguration(actions: [editAction])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { [weak self] _, _, completion in
            guard let self = self else { return completion(false) }
            self.deleteItem(atIndexPath: indexPath)
            completion(true)
        }
        deleteAction.image = UIImage(systemName: "trash")
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    func editItem(atIndexPath indexPath: IndexPath) {
        guard let cellData = viewModel.startEditing(atIndexPath: indexPath) else { return }
        presentEditController(key: cellData.key, value: cellData.value)
    }
    
    func deleteItem(atIndexPath indexPath: IndexPath) {
        do {
            try viewModel.deleteString(atIndexPath: indexPath).get()
            performTableViewUpdate(.delete([indexPath]))
            if #available(iOS 15.0, *) {
                tableView.reconfigureRows(at: tableView.indexPathsForVisibleRows ?? [])
            }
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
}

// MARK: - StringsMakerViewControllerDelegate

extension StringsDetailViewController: StringsMakerViewControllerDelegate {
    func stringsMaker(_ stringsMaker: StringsMakerViewController, didFinishWithKey key: String, value: String) {
        if stringsMaker is StringsCreatorViewController {
            createString(key: key, value: value)
        } else if stringsMaker is StringsEditorViewController {
            editString(key: key, value: value)
        }
    }
    
    func createString(key: String, value: String) {
        do {
            let update = try viewModel.addString(key: key, value: value).get()
            performTableViewUpdate(update)
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
    
    func editString(key: String, value: String) {
        do {
            let update = try viewModel.editString(key: key, value: value).get()
            performTableViewUpdate(update)
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
}

// MARK: - Building helpers

extension StringsDetailViewController {
    func makeButton(_ buttonType: BarButtonType) -> UIBarButtonItem {
        if buttonType == .export { return makeExportButton() }
        return UIBarButtonItem(
            image: buttonType.image,
            style: .plain,
            target: self,
            action: selector(for: buttonType)
        )
    }
    
    func makeExportButton() -> UIBarButtonItem {
        if #available(iOS 16.0, *) {
            return UIBarButtonItem(title: nil, image: BarButtonType.export.image, target: self, action: #selector(didTapExportButton), menu: makeExportMenu())
        } else {
            return UIBarButtonItem(image: BarButtonType.export.image, style: .plain, target: self, action: #selector(didTapExportButton))
        }
    }
    
    @available(iOS 16.0, *)
    func makeExportMenu() -> UIMenu {
        return UIMenu(title: "Export", children: [
            makeExportMenuAction(.json),
            makeExportMenuAction(.swift),
            makeExportMenuAction(.strings),
        ])
    }
    
    func selector(for buttonType: BarButtonType) -> Selector? {
        switch buttonType {
        case .add: return #selector(didTapAddButton)
        case .export: return #selector(didTapExportButton)
        case .info: return #selector(didTapInfoButton)
        case .rename: return #selector(didTapRenameButton)
        }
    }
    
    func makeExportMenuAction(_ exportAction: ExportMenuAction) -> UIAction {
        return UIAction(
            title: exportAction.title,
            image: exportAction.image,
            handler: makeHandler(for: exportAction)
        )
    }
    
    func makeHandler(for exportAction: ExportMenuAction) -> UIActionHandler {
        switch exportAction {
        case .strings: return makeStringsHandler()
        case .swift: return makeSwiftHandler()
        case .json: return makeJSONHandler()
        }
    }
    
    func makeStringsHandler() -> UIActionHandler {
        return { [weak self] _ in
            guard let self = self else { return }
            self.didTapExportStringsAction()
        }
    }
    
    func makeSwiftHandler() -> UIActionHandler {
        return { [weak self] _ in
            guard let self = self else { return }
            self.didTapExportSwiftAction()
        }
    }
    
    func makeJSONHandler() -> UIActionHandler {
        return { [weak self] _ in
            guard let self = self else { return }
            self.didTapExportJSONAction()
        }
    }
    
    enum BarButtonType: String {
        case add = "text.badge.plus"
        case export = "square.and.arrow.up"
        case info = "info.circle"
        case rename = "square.and.pencil.circle.fill"
        
        var image: UIImage? {
            var image = UIImage(systemName: rawValue)
            if #available(iOS 15.0, *), self == .add {
                image = image?.applyingSymbolConfiguration(.preferringMulticolor())
            }
            return image
        }
    }
    
    enum ExportMenuAction: String {
        case strings = "Strings"
        case swift = "Swift"
        case json = "JSON"
        
        var title: String { rawValue }
        var image: UIImage? {
            switch self {
            case .strings: return UIImage(systemName: "text.quote")
            case .swift: return UIImage(systemName: "swift")
            case .json: return UIImage(systemName: "ellipsis.curlybraces")
            }
        }
    }
}

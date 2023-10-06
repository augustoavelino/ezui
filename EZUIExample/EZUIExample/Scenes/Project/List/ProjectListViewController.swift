//
//  ProjectListViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 01/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class ProjectListViewController<ViewModel: ProjectListViewModelProtocol>:
    DSViewController<ViewModel>,
    DSCollectionViewModelDelegate,
    UITextFieldDelegate {
    
    // MARK: UI
    
    var isListEmpty: Bool { viewModel.isListEmpty() }
    var emptyListView: DSEmptyListView?
    
    lazy var collectionView: EZCollectionView = {
        let collectionView = EZCollectionView(
            cellClass: ProjectListCell.self,
            collectionViewLayout: makeCollectionViewLayout()
        )
        if #available(iOS 14.0, *) {
            collectionView.allowsMultipleSelectionDuringEditing = true
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    weak var confirmAction: UIAlertAction?
    
    // MARK: - Life cycle
    
    override init(viewModel: ViewModel) {
        super.init(viewModel: viewModel)
        title = "Projects"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupCollectionViewComponents()
    }
    
    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.leftBarButtonItem = makeOptionsButton()
        navigationItem.rightBarButtonItem = makeAddButton()
    }
    
    func fetchData() {
        do {
            try viewModel.fetchData().get()
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - Actions
    
    @objc func didTapOptionsButton(_ sender: UIBarButtonItem) {
        // TODO: Implementar actionSheet de options
    }
    
    @objc func didTapAddButton(_ sender: UIBarButtonItem) {
        presentCreateAlert()
    }
    
    @objc func didChangeTextFieldText(_ sender: UITextField) {
        confirmAction?.isEnabled = !(sender.text?.isEmpty ?? true)
    }
    
    func didTapExportFolder(indexPath: IndexPath) {
        // TODO: Implementar exportação
    }
    
    func didTapExportJSON(indexPath: IndexPath) {
        // TODO: Implementar exportação
    }
    
    // MARK: - Presenting
    
    func presentCreateAlert() {
        presentAlertWithTextField(
            title: "New Project",
            message: "Choose a name",
            textFieldPlaceholder: "Ex: Hello World"
        ) { [weak self] alertController, textField in
            guard let self = self else { return }
            textField.addTarget(self, action: #selector(didChangeTextFieldText), for: .valueChanged)
            textField.addTarget(self, action: #selector(didChangeTextFieldText), for: .editingChanged)
            textField.delegate = self
            let confirmAction = self.makeCreateConfirmAction(textField: textField)
            confirmAction.isEnabled = false
            self.confirmAction = confirmAction
            alertController.addAction(confirmAction)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
    }
    
    func presentRenameAlert(atIndexPath indexPath: IndexPath) {
        presentAlertWithTextField(
            title: "Rename Project",
            message: "Choose a new name",
            textFieldText: viewModel.dataForCell(atIndexPath: indexPath)?.name,
            textFieldPlaceholder: "Ex: Hello World"
        ) { [weak self] alertController, textField in
            guard let self = self else { return }
            textField.addTarget(self, action: #selector(didChangeTextFieldText), for: .valueChanged)
            textField.addTarget(self, action: #selector(didChangeTextFieldText), for: .editingChanged)
            textField.delegate = self
            let confirmAction = self.makeRenameConfirmAction(textField: textField, indexPath: indexPath)
            self.confirmAction = confirmAction
            alertController.addAction(confirmAction)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
    }
    
    func presentDeleteAlert(atIndexPath indexPath: IndexPath) {
        presentAlert(
            title: "Delete Project",
            message: "Are you sure you want to proceed?"
        ) { [weak self] alertController in
            guard let self = self else { return }
            alertController.addAction(self.makeAlertAction(.deleteProject(indexPath: indexPath), title: "Confirm", style: .destructive))
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
    }
    
    func presentImportController() {
        // TODO: Implementar exportação
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfCells(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellData = viewModel.dataForCell(atIndexPath: indexPath),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectListCell.reuseIdentifier, for: indexPath) as? ProjectListCell else { return UICollectionViewCell() }
        cell.configure(cellData: cellData, tintColor: view.tintColor)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCell(atIndexPath: indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let indexPath = indexPaths.first else { return nil }
        let folderAction = makeExportFolderAction(indexPath: indexPath)
        let jsonAction = makeExportJSONAction(indexPath: indexPath)
        let renameAction = makeRenameAction(for: indexPath)
        let deleteAction = makeDeleteAction(for: indexPath)
        return UIContextMenuConfiguration(actionProvider: { _ in
            return UIMenu(options: .displayInline, children: [
                UIMenu(title: "Export", options: .displayInline, children: [
                    folderAction,
                    jsonAction,
                ]),
                UIMenu(title: "Edit", options: .displayInline, children: [
                    renameAction,
                    UIMenu(options: .displayInline, children: [
                        deleteAction,
                    ]),
                ]),
            ])
        })
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
}

// MARK: - Building helpers

extension ProjectListViewController {
    
    // MARK: Collection view
    
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 16.0
        collectionViewLayout.sectionInset.left = spacing
        collectionViewLayout.sectionInset.right = spacing
        collectionViewLayout.minimumLineSpacing = spacing
        collectionViewLayout.minimumInteritemSpacing = spacing
        collectionViewLayout.itemSize = makeItemSize(forSpacing: spacing)
        return collectionViewLayout
    }
    
    func makeItemSize(forSpacing spacing: CGFloat) -> CGSize {
        let difference = spacing * 3.0
        let itemWidth = (view.bounds.width - difference) / 2.0
        return CGSize(
            width: itemWidth,
            height: itemWidth * 1.032
        )
    }
    
    // MARK: Actions
    
    func makeExportFolderAction(indexPath: IndexPath) -> UIMenuElement {
        return UIAction(title: "Folder", image: UIImage(systemName: "folder")) { [weak self] _ in
            guard let self = self else { return }
            self.didTapExportFolder(indexPath: indexPath)
        }
    }
    
    func makeExportJSONAction(indexPath: IndexPath) -> UIMenuElement {
        return UIAction(title: "JSON", image: UIImage(systemName: "ellipsis.curlybraces")) { [weak self] _ in
            guard let self = self else { return }
            self.didTapExportJSON(indexPath: indexPath)
        }
    }
    
    func makeRenameAction(for indexPath: IndexPath) -> UIAction {
        let deleteAction = UIAction(title: "Rename", handler: { [weak self] _ in
            guard let self = self else { return }
            self.presentRenameAlert(atIndexPath: indexPath)
        })
        deleteAction.image = UIImage(systemName: "square.and.pencil")
        return deleteAction
    }
    
    func makeDeleteAction(for indexPath: IndexPath) -> UIAction {
        let deleteAction = UIAction(title: "Delete", handler: { [weak self] _ in
            guard let self = self else { return }
            self.presentDeleteAlert(atIndexPath: indexPath)
        })
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.attributes = .destructive
        return deleteAction
    }
    
    func makeCreateConfirmAction(textField: UITextField) -> UIAlertAction {
        return UIAlertAction(title: "Confirm", style: .default) { [weak self, weak textField] _ in
            guard let self = self, let textField = textField else { return }
            self.viewModel.performAction(.createProject(name: textField.text))
        }
    }
    
    func makeRenameConfirmAction(textField: UITextField, indexPath: IndexPath) -> UIAlertAction {
        return UIAlertAction(title: "Confirm", style: .default) { [weak self, weak textField] _ in
            guard let self = self, let textField = textField else { return }
            self.viewModel.performAction(.renameProject(indexPath: indexPath, newName: textField.text))
        }
    }
    
    // MARK: - Bar buttons
    
    func makeOptionsButton() -> UIBarButtonItem {
        let buttonImage = UIImage(systemName: "ellipsis.circle")
        if #available(iOS 16.0, *) {
            return UIBarButtonItem(title: nil, image: buttonImage, target: nil, action: nil, menu: UIMenu(title: "", children: [
                makeDisplayModeAction(),
                UIMenu(title: "", options: .displayInline, children: [
                    makeSelectAction(),
                    makeSortMenu(),
                ])
            ]))
        } else {
            return UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(didTapOptionsButton))
        }
    }
    
    func makeAddButton() -> UIBarButtonItem {
        let buttonImage = UIImage(systemName: "folder.fill.badge.plus")
        if #available(iOS 16.0, *) {
            return UIBarButtonItem(title: nil, image: buttonImage, target: self, action: #selector(didTapAddButton), menu: UIMenu(title: "Add", children: [
                makeImportAction(),
                makeCreateAction(),
            ]))
        } else {
            return UIBarButtonItem(image: buttonImage, style: .plain, target: self, action: #selector(didTapAddButton))
        }
    }
    
    // MARK: Options
    
    func makeDisplayModeAction() -> UIMenuElement {
        return UIAction(title: "View as Gallery", image: UIImage(systemName: "square.grid.2x2")) { _ in
            print("PROJECTS: CHANGE DISPLAY MODE")
        }
    }
    
    func makeSelectAction() -> UIMenuElement {
        return UIAction(title: "Select Projects", image: UIImage(systemName: "checkmark.circle")) { _ in
            print("PROJECTS: START PROJECT SELECTION")
        }
    }
    
    func makeSortMenu() -> UIMenuElement {
        let sortImage = UIImage(systemName: "arrow.up.arrow.down")
        let children: [UIMenuElement] = [
            makeSortDefaultAction(),
            makeSortDateEditedAction(),
            makeSortDateCreatedAction(),
            makeSortNameAction(),
            makeSortOrderMenu(),
        ]
        if #available(iOS 16.0, *) {
            return UIMenu(title: "Sort By", subtitle: "Default (Date Edited)", image: sortImage, children: children)
        } else {
            return UIMenu(title: "Sort By", image: sortImage, children: children)
        }
    }
    
    func makeSortDefaultAction() -> UIMenuElement {
        let action = UIAction(title: "Default (Date Updated)") { _ in
            print("PROJECTS: CHANGE DISPLAY MODE -> DEFAULT")
        }
        action.state = .on
        return action
    }
    
    func makeSortDateEditedAction() -> UIMenuElement {
        return UIAction(title: "Date Updated") { _ in
            print("PROJECTS: CHANGE DISPLAY MODE -> DATE UPDATED")
        }
    }
    
    func makeSortDateCreatedAction() -> UIMenuElement {
        return UIAction(title: "Date Created") { _ in
            print("PROJECTS: CHANGE DISPLAY MODE -> DATE CREATED")
        }
    }
    
    func makeSortNameAction() -> UIMenuElement {
        return UIAction(title: "Name") { _ in
            print("PROJECTS: CHANGE DISPLAY MODE -> NAME")
        }
    }
    
    func makeSortOrderMenu() -> UIMenuElement {
        return UIMenu(title: "", options: .displayInline, children: [
            makeAscendingAction(),
            makeDescendingAction(),
        ])
    }
    
    func makeAscendingAction() -> UIMenuElement {
        let action = UIAction(title: "Ascending") { _ in
            print("PROJECTS: SORT ASCENDING")
        }
        action.state = .on
        return action
    }
    
    func makeDescendingAction() -> UIMenuElement {
        return UIAction(title: "Descending") { _ in
            print("PROJECTS: SORT DESCENDING")
        }
    }
    
    // MARK: Add
    
    func makeCreateAction() -> UIMenuElement {
        return UIAction(title: "Create", image: UIImage(systemName: "square.and.pencil")) { [weak self] _ in
            guard let self = self else { return }
            self.presentCreateAlert()
        }
    }
    
    func makeImportAction() -> UIMenuElement {
        return UIAction(title: "Import", image: UIImage(systemName: "square.and.arrow.down")) { [weak self] _ in
            guard let self = self else { return }
            self.presentImportController()
        }
    }
}

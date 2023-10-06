//
//  ProjectDetailViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 01/07/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit
//import MobileCoreServices
//import UniformTypeIdentifiers
import Photos
import PhotosUI

class ProjectDetailViewController<ViewModel: ProjectDetailViewModelProtocol>:
    DSViewController<ViewModel>,
    DSCollectionViewModelDelegate,
    PHPickerViewControllerDelegate,
    UITextFieldDelegate {
    
    // MARK: UI
    
    var isListEmpty: Bool { false }
    var emptyListView: DSEmptyListView?
    
    lazy var scrollView = UIScrollView()
    lazy var stackView = EZStackView(
        axis: .vertical,
        arrangedSubviews: [headerView, collectionView,]
    )
    lazy var headerView = ProjectDetailHeaderView()
    // TODO: Corrigir construção da tela de detalhes do projeto
    lazy var collectionView: EZCollectionView = {
        let collectionView = EZCollectionView(
            cellClass: ProjectDetailCell.self,
            collectionViewLayout: makeCollectionViewLayout()
        )
        collectionView.layout { $0.height == 402.0 }
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        return collectionView
    }()
    
    weak var confirmAction: UIAlertAction?
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerView.bannerBackgroundColor = getHeaderColor()
        configureNavigationBarOnAppear()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureNavigationBarOnDisappear()
    }
    
    func configureNavigationBarOnAppear() {
        navigationController?.navigationBar.tintColor = .label
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func configureNavigationBarOnDisappear() {
        navigationController?.navigationBar.tintColor = nil
        navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        view.backgroundColor = .systemBackground
        setupNavigationBar()
        setupScrollView()
        setupStackView()
    }
    
    func setupNavigationBar() {
        navigationItem.largeTitleDisplayMode = .never
        navigationItem.setRightBarButtonItems([
            .safeFlexibleSpace(),
            makeChangeBannerButton(),
            makeRenameButton(),
        ], animated: false)
    }
    
    func setupScrollView() {
        scrollView.contentInsetAdjustmentBehavior = .never
        view.addSubview(scrollView)
        scrollView.layout {
            $0.top == view.topAnchor
            $0.bottom == view.safeAreaLayoutGuide.bottomAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
        }
    }
    
    func setupStackView() {
        scrollView.addSubview(stackView)
        stackView.layout {
            $0.top == scrollView.topAnchor
            $0.bottom == scrollView.bottomAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
        }
    }
    
    func setupHeaderView() {
        view.addSubview(headerView)
        headerView.layout {
            $0.top == view.topAnchor
            $0.leading == view.leadingAnchor
            $0.trailing == view.trailingAnchor
        }
    }
    
    // MARK: - Actions
    
    @objc func didChangeTextFieldText(_ sender: UITextField) {
        confirmAction?.isEnabled = !(sender.text?.isEmpty ?? true)
    }
    
    @objc func didTapChangeBannerButton(_ sender: UIBarButtonItem) {
        if #available(iOS 14.0, *) {
            presentImagePickerForIOS14()
        } else {
            presentImagePickerForEarlierIOS()
        }
    }
    
    @objc func didTapRenameButton(_ sender: UIBarButtonItem) {
        presentAlertWithTextField(
            title: "Rename Project",
            message: "Choose a new name",
            textFieldText: viewModel.dataForHeader()?.projectName,
            textFieldPlaceholder: "Ex: Hello World"
        ) { [weak self] alertController, textField in
            guard let self = self else { return }
            textField.addTarget(self, action: #selector(didChangeTextFieldText), for: .valueChanged)
            textField.addTarget(self, action: #selector(didChangeTextFieldText), for: .editingChanged)
            textField.delegate = self
            let confirmAction = self.makeRenameConfirmAction(textField: textField)
            self.confirmAction = confirmAction
            alertController.addAction(confirmAction)
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        }
    }
    
    // MARK: - Presenting
    
    @available(iOS 14.0, *)
    func presentImagePickerForIOS14() {
        var configuration = PHPickerConfiguration(photoLibrary: .shared())
        configuration.selectionLimit = 1
        configuration.filter = .images
        let pickerController = PHPickerViewController(configuration: configuration)
        pickerController.delegate = self
        present(pickerController, animated: true)
    }
    
    func presentImagePickerForEarlierIOS() {
        let pickerController = UIImagePickerController()
        pickerController.sourceType = .photoLibrary
        pickerController.mediaTypes = ["public.image"]
        pickerController.allowsEditing = true
    }
    
    // MARK: - Data
    
    func reloadData() {
        guard let headerData = viewModel.dataForHeader() else { return }
        headerView.configure(headerData)
    }
    
    func fetchData() {
        do {
            try viewModel.fetchData().get()
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
    
    // MARK: - Getters
    
    func getHeaderColor() -> UIColor {
        if let color = (UIApplication.shared.delegate as? AppDelegate)?.window?.tintColor {
            return color
        }
        return .systemBlue
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int { viewModel.numberOfSections() }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { viewModel.numberOfCells(in: section) }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellData = viewModel.dataForCell(atIndexPath: indexPath),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProjectDetailCell.reuseIdentifier, for: indexPath) as? ProjectDetailCell else { return UICollectionViewCell() }
        cell.configure(cellData, tintColor: view.tintColor)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectCell(atIndexPath: indexPath)
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    
    // MARK: - PHPickerViewControllerDelegate
    
    @available(iOS 14.0, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
    }
    
    // MARK: - Building helpers
    
    func makeCollectionViewLayout() -> UICollectionViewLayout {
        let collectionViewLayout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12.0
        let margin = spacing * 2.0
        collectionViewLayout.scrollDirection = .vertical
        collectionViewLayout.sectionInset = UIEdgeInsets(
            top: spacing,
            left: margin,
            bottom: spacing,
            right: margin
        )
        collectionViewLayout.minimumLineSpacing = spacing
        collectionViewLayout.minimumInteritemSpacing = spacing
        collectionViewLayout.estimatedItemSize = UICollectionView.layoutFittingCompressedSize
        collectionViewLayout.itemSize = makeItemSize(forSpacing: spacing, margin: margin)
        return collectionViewLayout
    }
    
    func makeItemSize(forSpacing spacing: CGFloat, margin: CGFloat) -> CGSize {
        let itemCount = 3.0
        let itemWidth = (view.bounds.width - (margin * 2.0) - (spacing * (itemCount - 1.0))) / itemCount
        let itemHeight = itemWidth / 0.9
        return CGSize(
            width: itemWidth,
            height: itemHeight
        )
    }
    
    func makeExportButton() -> UIBarButtonItem {
        if #available(iOS 14.0, *) {
            return makeBarButton(
                .export(.json),
                iconName: "square.and.arrow.up",
                menu: UIMenu(children: [
                    makeAction(.export(.json), title: "JSON", iconName: "ellipsis.curlybraces"),
                    makeAction(.export(.folder), title: "Folder", iconName: "folder"),
                ])
            )
        }
        return makeBarButton(.export(.json), iconName: "square.and.arrow.up")
    }
    
    func makeChangeBannerButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(systemName: "photo.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapChangeBannerButton)
        )
    }
    
    func makeRenameButton() -> UIBarButtonItem {
        return UIBarButtonItem(
            image: UIImage(systemName: "square.and.pencil.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapRenameButton)
        )
    }
    
    func makeRenameConfirmAction(textField: UITextField) -> UIAlertAction {
        return UIAlertAction(title: "Confirm", style: .default) { [weak self, weak textField] _ in
            guard let self = self, let textField = textField else { return }
            self.viewModel.performAction(.rename(textField.text))
        }
    }
}

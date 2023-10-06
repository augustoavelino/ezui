//
//  IconographyDemoViewController.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 09/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

class IconographyDemoViewController<ViewModel: IconographyDemoViewModelProtocol>:
    DSViewController<ViewModel>,
    DSTableViewModelDelegate,
    UISearchControllerDelegate,
    UISearchResultsUpdating {
    
    // MARK: UI
    
    var isListEmpty: Bool { viewModel.isListEmpty() }
    var emptyListView: DSEmptyListView?

    lazy var tableView: EZTableView = {
        let tableView = EZTableView(cellClass: IconographyDemoCell.self, separatorStyle: .singleLine)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    weak var segmentedControl: UISegmentedControl?
    
    // MARK: - Life cycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchData()
        reloadData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupSegmentedControl()
    }
    
    // MARK: - Setup
    
    override func setupUI() {
        title = .appString(.iconography(.title))
        setupSearchBar()
        setupTableViewComponents()
    }
    
    func setupSearchBar() {
        let searchController = UISearchController()
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupSegmentedControl() {
        setToolbarItems([
            .safeFlexibleSpace(),
            UIBarButtonItem(customView: makeSegmentedControl()),
            .safeFlexibleSpace(),
        ], animated: false)
    }
    
    // MARK: - Actions
    
    @objc func didChangeSegment(_ sender: UISegmentedControl) {
        let showsAll = sender.selectedSegmentIndex == 0
        viewModel.setFilterMode(showsAll ? .all : .favorites)
        tableView.reloadData()
    }
    
    // MARK: - Data
    
    func reloadData() {
        navigationItem.rightBarButtonItem = makeBarButton(
            .switchColorMode,
            iconName: viewModel.iconNameForColorMode()
        )
    }
    
    func fetchData() {
        do {
            try viewModel.fetchIconList().get()
            updateSegmentTitles()
        } catch {
            presentErrorAlert(message: error.localizedDescription)
            updateSegmentTitles()
        }
    }
    
    func updateSegmentTitles() {
        let titles = viewModel.segmentTitles()
        for (index, title) in titles.enumerated() {
            segmentedControl?.setTitle(title, forSegmentAt: index)
        }
    }
    
    func makeSegmentedControl() -> UISegmentedControl {
        let segmentedControl = UISegmentedControl(items: viewModel.segmentTitles())
        self.segmentedControl = segmentedControl
        segmentedControl.addTarget(self, action: #selector(didChangeSegment), for: .valueChanged)
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCells(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellData = viewModel.dataForCell(atIndexPath: indexPath),
              let cell = tableView.dequeueReusableCell(withIdentifier: IconographyDemoCell.reuseIdentifier, for: indexPath) as? IconographyDemoCell else { return UITableViewCell() }
        cell.configure(cellData)
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        do {
            try viewModel.didSelectCell(atIndexPath: indexPath).get()
            let isShowingAll = segmentedControl?.selectedSegmentIndex == 0
            DispatchQueue.main.async {
                self.updateSegmentTitles()
                if isShowingAll {
                    self.reconfigureCells(atIndexPaths: [indexPath])
                } else {
                    self.reloadCells()
                }
            }
        } catch {
            presentErrorAlert(message: error.localizedDescription)
        }
    }
    
    func reconfigureCells(atIndexPaths indexPaths: [IndexPath]) {
        tableView.beginUpdates()
        if #available(iOS 15.0, *) {
            tableView.reconfigureRows(at: indexPaths)
        } else {
            tableView.reloadRows(at: indexPaths, with: .none)
        }
        tableView.endUpdates()
    }
    
    func reloadCells() {
        tableView.reloadData()
    }
    
    func search(_ query: String?) {
        viewModel.search(query) { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - UISearchControllerDelegate
    
    func didDismissSearchController(_ searchController: UISearchController) {
        search(searchController.searchBar.text)
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        search(searchController.searchBar.text)
    }
    
    // MARK: - UISearchResultsUpdating
    
    func updateSearchResults(for searchController: UISearchController) {
        search(searchController.searchBar.text)
    }
    
    @available(iOS 16.0, *)
    func updateSearchResults(for searchController: UISearchController, selecting searchSuggestion: UISearchSuggestion) {
        search(searchSuggestion.localizedSuggestion)
    }
}

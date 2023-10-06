//
//  IconographyDemoViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 09/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

enum IconographyFilterMode: String {
    case all, favorites
}

enum IconographyColorMode: String {
    case label, tinted, hierarchical, multicolor
}

protocol IconographyDemoCellDataProtocol {
    var imageName: String { get }
    var colorMode: IconographyColorMode { get }
    var isFavorite: Bool { get }
}

protocol IconographyDemoViewModelProtocol: DSViewModelProtocol where ActionType == IconographyDemoAction {
    associatedtype CellData: IconographyDemoCellDataProtocol
    
    func segmentTitles() -> [String]
    func fetchIconList() -> Result<Void, Error>
    func isListEmpty() -> Bool
    func numberOfSections() -> Int
    func numberOfCells(inSection section: Int) -> Int
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData?
    func setFilterMode(_ filterMode: IconographyFilterMode)
    func search(_ query: String?, completion: @escaping () -> Void)
    func iconNameForColorMode() -> String
    func didSelectCell(atIndexPath indexPath: IndexPath) -> Result<Void, Error>
}

class IconographyDemoViewModel: DSViewModel<IconographyDemoAction>, IconographyDemoViewModelProtocol {
    typealias CellData = IconographyDemoCellData
    
    // MARK: Properties
    
    let repository: IconographyRepoProtocol
    weak var coordinator: IconographyCoordinatorProtocol?
    var tableDelegate: DSTableViewModelDelegate? { delegate as? DSTableViewModelDelegate }
    
    var searchQuery: String?
    var rawData: [CellData] = []
    var favoritesData: [CellData] { rawData.lazy.filter({ $0.isFavorite }) }
    var cellData: [CellData] = []
    var filterMode: IconographyFilterMode = .all
    var colorMode: IconographyColorMode = .label
    
    // MARK: - Life cycle
    
    init(
        repository: IconographyRepoProtocol,
        coordinator: IconographyCoordinatorProtocol
    ) {
        self.coordinator = coordinator
        self.repository = repository
    }
    
    deinit {
        coordinator?.performRoute(.back, animated: true)
    }
    
    // MARK: - IconographyDemoViewModelProtocol
    
    func segmentTitles() -> [String] {
        return [
            .appStringFormatted(.iconography(.segmentAll), numberOfAllItems()),
            .appStringFormatted(.iconography(.segmentFavorites), numberOfFavorites()),
        ]
    }
    
    func isListEmpty() -> Bool { numberOfCells(inSection: 0) == 0 }
    func numberOfAllItems() -> Int { rawData.count }
    func numberOfFavorites() -> Int { favoritesData.count }
    func numberOfSections() -> Int { 1 }
    
    func numberOfCells(inSection section: Int) -> Int {
        return cellData.count
    }
    
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData? {
        guard indexPath.row < cellData.count else { return nil }
        return cellData[indexPath.row]
    }
    
    func fetchIconList() -> Result<Void, Error> {
        do {
            let favorites = try repository.fetchFavorites().get()
            rawData = try repository.fetchItems().get()
                .compactMap { item in
                    let isFavorite = favorites.contains(where: { $0.imageName == item.imageName })
                    return IconographyDemoCellData(imageName: item.imageName, colorMode: colorMode, isFavorite: isFavorite)
                }
            reloadIconList()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func setFilterMode(_ filterMode: IconographyFilterMode) {
        self.filterMode = filterMode
        reloadIconList()
    }
    
    func search(_ query: String?, completion: @escaping () -> Void) {
        self.searchQuery = query
        DispatchQueue.global(qos: .userInitiated).async {
            self.reloadIconList()
            completion()
        }
    }
    
    func filterItems(_ items: [CellData], searchQuery: String) -> [CellData] {
        return items.filter({ $0.imageName.contains(searchQuery.lowercased()) })
    }
    
    func iconNameForColorMode() -> String {
        switch colorMode {
        case .label: return "paintbrush"
        case .tinted: return "paintbrush.fill"
        case .hierarchical: return "paintpalette"
        case .multicolor:return "paintpalette.fill"
        }
    }
    
    func didSelectCell(atIndexPath indexPath: IndexPath) -> Result<Void, Error> {
        guard indexPath.row < cellData.count else { return .success(()) }
        let selectedData = cellData[indexPath.row]
        do {
            try repository.toggleFavoriteState(forItemNamed: selectedData.imageName).get()
            return fetchIconList()
        } catch {
            return .failure(error)
        }
    }
    
    override func performAction(_ actionType: IconographyDemoAction) {
        switch actionType {
        case .switchColorMode: switchColorMode()
        }
    }
    
    func switchColorMode() {
        togglecolorMode()
        reloadIconList()
        repository.saveColorMode(colorMode.rawValue)
        delegate?.reloadData()
    }
    
    // MARK: - Helpers
    
    func loadcolorMode() {
        guard let rawColorMode = try? repository.getSavedColorMode().get(),
              let colorMode = IconographyColorMode(rawValue: rawColorMode) else { return }
        self.colorMode = colorMode
    }
    
    func togglecolorMode() {
        switch colorMode {
        case .label: colorMode = .tinted
        case .tinted:
            if #available(iOS 15.0, *) {
                colorMode = .hierarchical
            } else {
                colorMode = .label
            }
        case .hierarchical: colorMode = .multicolor
        case .multicolor: colorMode = .label
        }
    }
    
    func reloadIconList() {
        var resultData = displayedIconList()
        if let searchQuery = searchQuery, !searchQuery.isEmpty {
            resultData = filterItems(resultData, searchQuery: searchQuery)
        }
        cellData = resultData.compactMap {
            IconographyDemoCellData(imageName: $0.imageName, colorMode: colorMode, isFavorite: $0.isFavorite)
        }
        tableDelegate?.performTableViewUpdate(.reloadData, with: .none)
    }
    
    func displayedIconList() -> [CellData] {
        var resultData: [CellData]
        switch filterMode {
        case .all: resultData = rawData
        case .favorites: resultData = favoritesData
        }
        return resultData
    }
}

// MARK: - Action type

enum IconographyDemoAction: DSActionType {
    case switchColorMode
    
    var identifier: String {
        switch self {
        case .switchColorMode: return "iconography/switch_color_mode"
        }
    }
}

//
//  ColorPaletteListViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 12/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

protocol ColorPaletteListCellDataProtocol {
    var name: String { get }
    var dateCreatedText: String { get }
    var dateUpdatedText: String { get }
}

protocol ColorPaletteListViewModelProtocol: DSViewModelProtocol where ActionType == ColorPaletteListAction {
    associatedtype CellData: ColorPaletteListCellDataProtocol
    
    func fetchData() -> Result<Void, Error>
    func footnote() -> String
    
    func currentSortType() -> ColorPaletteListSortType
    func currentSortOrder() -> ColorPaletteListSortOrder
    
    func isListEmpty() -> Bool
    func numberOfSections() -> Int
    func numberOfCells(inSection section: Int) -> Int
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData?
    func didSelectCell(atIndexPath indexPath: IndexPath)
}

class ColorPaletteListViewModel: DSViewModel<ColorPaletteListAction>, ColorPaletteListViewModelProtocol {
    typealias CellData = ColorPaletteListCellData
    
    // MARK: Properties
    
    let repository: ColorPaletteListRepoProtocol
    weak var coordinator: ColorPaletteCoordinatorProtocol?
    var tableDelegate: DSTableViewModelDelegate? { delegate as? DSTableViewModelDelegate }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm - dd/MM"
        return formatter
    }()
    
    var cellData: [CellData] = []
    var editingIndexPath: IndexPath?
    var deletingIndexPath: IndexPath?
    
    // MARK: - Life cycle
    
    init(
        repository: ColorPaletteListRepoProtocol,
        coordinator: ColorPaletteCoordinatorProtocol?
    ) {
        self.repository = repository
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator?.performRoute(.back, animated: true)
    }
    
    // MARK: - CRUD
    
    func fetchData() -> Result<Void, Error> {
        do {
            let data = try repository.fetchPaletteList().get()
            cellData = data.compactMap { parsePalette($0) }
            tableDelegate?.performTableViewUpdate(.reloadData, with: .none)
            delegate?.reloadData()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func footnote() -> String {
        let paletteCount = numberOfCells(inSection: 0)
        return "\(paletteCount) " + (paletteCount == 1 ? "palette" : "palettes")
    }
    
    func isListEmpty() -> Bool { cellData.isEmpty }
    func numberOfSections() -> Int { 1 }
    func numberOfCells(inSection section: Int) -> Int { cellData.count }
    
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData? {
        guard indexPath.row < cellData.count else { return nil }
        return cellData[indexPath.row]
    }
    
    func currentSortType() -> ColorPaletteListSortType { repository.currentSortType() }
    func currentSortOrder() -> ColorPaletteListSortOrder { repository.currentSortOrder() }
    
    // MARK: - Actions
    
    func didSelectCell(atIndexPath indexPath: IndexPath) {
        do {
            let palette = try repository.palette(atIndex: indexPath.row).get()
            navigateToDetail(palette: palette)
        } catch {
            print("🛑 " + error.localizedDescription)
        }
    }
    
    override func performAction(_ actionType: ActionType) {
        switch actionType {
        case .createPalette: presentCreateAlert()
        case .importPalette: presentImportController()
        case .renamePalette(let indexPath): presentRenameAlert(indexPath: indexPath)
        case .deletePalette(let indexPath): presentDeleteAlert(indexPath: indexPath)
        case .paletteInfo(let indexPath): presentInfoController(indexPath: indexPath)
        case .exportPalette(let indexPath, let exportType): presentExportController(indexPath: indexPath, exportType: exportType)
        case .options: presentOptionsController()
        case .sortType(let sortType): applySortType(sortType)
        case .sortOrder(let sortOrder): applySortOrder(sortOrder)
        }
    }
    
    // MARK: - Navigation
    
    func navigateToDetail(palette: Palette) {
        coordinator?.performRoute(.detail(palette: palette), animated: true)
    }
    
    func presentCreateAlert() {
        coordinator?.performRoute(.createPalette(delegate: self), animated: true)
    }
    
    func presentImportController() {
        print("PRESENT IMPORT")
    }
    
    func presentInfoController(indexPath: IndexPath) {
        print("PRESENT INFO FOR \(indexPath.row)")
    }
    
    func presentExportController(indexPath: IndexPath, exportType: ColorPaletteExportType) {
        
    }
    
    func presentRenameAlert(indexPath: IndexPath) {
        editingIndexPath = indexPath
        coordinator?.performRoute(.renamePalette(delegate: self), animated: true)
    }
    
    func presentDeleteAlert(indexPath: IndexPath) {
        deletingIndexPath = indexPath
        coordinator?.performRoute(.deletePalette(delegate: self), animated: true)
    }
    
    func presentOptionsController() {
        
    }
    
    func applySortType(_ type: ColorPaletteListSortType) {
        do {
            try repository.applySort(type: type).get()
            try fetchData().get()
        } catch {
            print(error)
        }
    }
    
    func applySortOrder(_ order: ColorPaletteListSortOrder) {
        do {
            try repository.applySort(order: order).get()
            try fetchData().get()
        } catch {
            print(error)
        }
    }
    
    // MARK: - Parsing
    
    func parsePalette(_ palette: Palette) -> CellData {
        var dateCreatedText = "Created: "
        var dateUpdatedText = "Updated: "
        if let dateCreated = palette.dateCreated {
            dateCreatedText += dateFormatter.string(from: dateCreated)
        }
        if let dateUpdated = palette.dateUpdated {
            dateUpdatedText += dateFormatter.string(from: dateUpdated)
        }
        return ColorPaletteListCellData(
            name: palette.name ?? "Untitled",
            dateCreatedText: dateCreatedText,
            dateUpdatedText: dateUpdatedText
        )
    }
}

// MARK: - ProjectAlertDelegate

extension ColorPaletteListViewModel {
    func alertDidCancel(_ alert: UIAlertController) {
        editingIndexPath = nil
        deletingIndexPath = nil
    }
}

// MARK: - ProjectNameAlertDelegate

extension ColorPaletteListViewModel: PaletteCreateAlertDelegate {
    func alert(_ alert: UIAlertController, didCreateWith paletteName: String?) {
        do {
            let (palette, paletteIndex) = try repository.createPalette(named: paletteName).get()
            cellData.insert(parsePalette(palette), at: paletteIndex)
            tableDelegate?.performTableViewUpdate(.insert([IndexPath(row: paletteIndex, section: 0)]), with: .top)
            delegate?.reloadData()
        } catch {
            print(error)
        }
    }
}

// MARK: - ColorPaletteRenameAlertDelegate

extension ColorPaletteListViewModel: PaletteRenameAlertDelegate {
    func currentTextFieldText() -> String? {
        guard let editingIndexPath = editingIndexPath else { return nil }
        do {
            let palette = try repository.palette(atIndex: editingIndexPath.row).get()
            return palette.name
        } catch {
            print(error)
            return nil
        }
    }
    
    func alert(_ alert: UIAlertController, didRenameWith paletteName: String?) {
        guard let editingIndexPath = editingIndexPath else { return }
        do {
            let (palette, newRow) = try repository.renamePalette(atIndex: editingIndexPath.row, newName: paletteName).get()
            let newData = parsePalette(palette)
            cellData.replaceSubrange(editingIndexPath.row...editingIndexPath.row, with: [newData])
            tableDelegate?.performTableViewUpdate(.reconfigure([editingIndexPath]), with: .none)
            if newRow != editingIndexPath.row {
                let movedData = cellData.remove(at: editingIndexPath.row)
                cellData.insert(movedData, at: newRow)
                let newIndexPath = IndexPath(row: newRow, section: editingIndexPath.section)
                tableDelegate?.performTableViewUpdate(.move(at: editingIndexPath, to: newIndexPath), with: .automatic)
            } else {
                _ = try fetchData().get()                
            }
        } catch {
            print(error)
        }
    }
}

// MARK: - ProjectDeleteAlertDelegate

extension ColorPaletteListViewModel: PaletteDeleteAlertDelegate {
    func alertDidConfirmDeletion(_ alert: UIAlertController) {
        guard let deletingIndexPath = deletingIndexPath else { return }
        do {
            try repository.removePalette(atIndex: deletingIndexPath.row).get()
            cellData.remove(at: deletingIndexPath.row)
            tableDelegate?.performTableViewUpdate(.delete([deletingIndexPath]), with: .top)
            delegate?.reloadData()
        } catch {
            print(error)
        }
    }
}

// MARK: Action types

enum ColorPaletteListAction: DSActionType {
    case createPalette
    case importPalette
    case renamePalette(indexPath: IndexPath)
    case deletePalette(indexPath: IndexPath)
    case paletteInfo(indexPath: IndexPath)
    case exportPalette(indexPath: IndexPath, type: ColorPaletteExportType)
    case options
    case sortType(ColorPaletteListSortType)
    case sortOrder(ColorPaletteListSortOrder)
    
    var identifier: String {
        switch self {
        case .createPalette: return "palette/add_color/create"
        case .importPalette: return "palette/add_color/import"
        case .renamePalette(let indexPath): return "palette/rename/\(indexPath.row)"
        case .deletePalette(let indexPath): return "palette/delete_color/\(indexPath.row)"
        case .paletteInfo(let indexPath): return "palette/info/\(indexPath.row)"
        case .exportPalette(let indexPath, let exportType): return "palette/export/\(indexPath.row)/" + exportType.identifier
        case .options: return "palette/options"
        case .sortType(let type): return "palette/sort/\(type.identifier)"
        case .sortOrder(let order): return "palette/sort/\(order.identifier)"
        }
    }
}

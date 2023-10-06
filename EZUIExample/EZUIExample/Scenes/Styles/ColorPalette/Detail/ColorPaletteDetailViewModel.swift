//
//  ColorPaletteDetailViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 10/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

// MARK: Cell data

protocol ColorPaletteDetailCellDataProtocol {
    var color: UIColor { get }
    var name: String { get }
}

protocol ColorPaletteDetailViewModelProtocol: DSViewModelProtocol where ActionType == ColorPaletteDetailAction {
    associatedtype CellData: ColorPaletteDetailCellDataProtocol
    
    func fetchData() -> Result<Void, Error>
    func nameForPalette() -> String
    func footnote() -> String
    
    func isListEmpty() -> Bool
    func numberOfSections() -> Int
    func numberOfCells(inSection section: Int) -> Int
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData?
}

class ColorPaletteDetailViewModel: DSViewModel<ColorPaletteDetailAction>, ColorPaletteDetailViewModelProtocol {
    typealias CellData = ColorPaletteDetailCellData
    
    // MARK: Properties
    
    let repository: ColorPaletteDetailRepoProtocol
    weak var coordinator: ColorPaletteCoordinatorProtocol?
    var tableDelegate: DSTableViewModelDelegate? { delegate as? DSTableViewModelDelegate }
    
    var cellData: [CellData] = []
    var editingIndexPath: IndexPath?
    var deletingIndexPath: IndexPath?
    
    // MARK: - Life cycle
    
    init(repository: ColorPaletteDetailRepoProtocol, coordinator: ColorPaletteCoordinatorProtocol) {
        self.repository = repository
        self.coordinator = coordinator
    }
    
    // MARK: - Data
    
    func nameForPalette() -> String {
        return repository.palette.name ?? "Untitled"
    }
    
    func footnote() -> String {
        let colorCount = cellData.count
        return "\(colorCount) " + (colorCount == 1 ? "color" : "colors")
    }
    
    func canRenamePalette(_ newName: String?) -> Bool {
        guard let newName = newName, !newName.isEmpty else { return false }
        return newName != nameForPalette()
    }
    
    func fetchData() -> Result<Void, Error> {
        do {
            let data = try repository.fetchColorList().get()
            cellData = data.compactMap { parseColor($0) }
            tableDelegate?.performTableViewUpdate(.reloadData, with: .none)
            delegate?.reloadData()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Presenting
    
    override func performAction(_ actionType: ActionType) {
        switch actionType {
        case .createColor: presentCreateController()
        case .importColor: presentImportController()
        case .editColor(let indexPath): presentEditController(forIndexPath: indexPath)
        case .deleteColor(let indexPath): presentDeleteAlert(forIndexPath: indexPath)
        case .exportPalette(let type): presentExportController(type)
        case .renamePalette: presentRenameAlert()
        }
    }
    
    func presentCreateController() {
        coordinator?.performRoute(.createColor(delegate: self), animated: true)
    }
    
    func presentImportController() {
        print("PRESENT IMPORT")
    }
    
    func presentEditController(forIndexPath indexPath: IndexPath) {
        editingIndexPath = indexPath
        do {
            let color = try repository.color(atIndex: indexPath.row).get()
            coordinator?.performRoute(.editColor(color: color, delegate: self), animated: true)
        } catch {
            print(error)
        }
    }
    
    func presentDeleteAlert(forIndexPath indexPath: IndexPath) {
        deletingIndexPath = indexPath
        coordinator?.performRoute(.deleteColor(delegate: self), animated: true)
    }
    
    func presentExportController(_ exportType: ColorPaletteExportType) {
        do {
            let url = try urlForExportType(exportType).get()
            coordinator?.performRoute(.exportPalette(items: [url]), animated: true)
        } catch {
            print(error)
        }
    }
    
    func presentRenameAlert() {
        coordinator?.performRoute(.renamePalette(delegate: self), animated: true)
    }
    
    // MARK: - Export
    
    func urlForExportType(_ exportType: ColorPaletteExportType) -> Result<URL, Error> {
        switch exportType {
        case .swift: return repository.generatePaletteSwiftFile()
        case .json: return repository.generatePaletteJSONFile()
        case .png: return repository.generatePalettePNGFile()
        case .svg: return repository.generatePaletteSVGFile()
        }
    }
    
    // MARK: Data
    
    func isListEmpty() -> Bool { cellData.isEmpty }
    func numberOfSections() -> Int { 1 }
    func numberOfCells(inSection section: Int) -> Int { cellData.count }
    
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData? {
        guard indexPath.row < cellData.count else { return nil }
        return cellData[indexPath.row]
    }
    
    func parseColor(_ paletteColor: PaletteColor) -> CellData {
        let colorHex = Int(paletteColor.colorHex)
        return ColorPaletteDetailCellData(
            name: paletteColor.name ?? "Untitled",
            color: UIColor(rgba: colorHex)
        )
    }
}

// MARK: - ColorPickerViewControllerDelegate

extension ColorPaletteDetailViewModel: ColorPickerViewControllerDelegate {
    func colorPicker(_ colorPicker: ColorPickerViewController, didFinishWith color: UIColor, name colorName: String) {
        if editingIndexPath != nil {
            editColor(color, colorName: colorName)
            editingIndexPath = nil
        } else {
            addColor(color, colorName: colorName)
        }
    }
    
    func colorPickerDidCancel(_ colorPicker: ColorPickerViewController) {
        editingIndexPath = nil
    }
    
    func addColor(_ color: UIColor, colorName name: String) {
        do {
            let (color, colorIndex) = try repository.addColor(name: name, colorHex: color.rgbaInt()).get()
            cellData.insert(parseColor(color), at: colorIndex)
            tableDelegate?.performTableViewUpdate(.insert([IndexPath(row: colorIndex, section: 0)]), with: .top)
            delegate?.reloadData()
        } catch {
            print(error)
        }
    }
    
    func editColor(_ color: UIColor, colorName name: String) {
        guard let editingIndexPath = editingIndexPath else { return }
        do {
            try repository.editColor(atIndex: editingIndexPath.row, name: name, colorHex: color.rgbaInt()).get()
            _ = try fetchData().get()
        } catch {
            print(error)
        }
    }
}

// MARK: - PaletteRenameAlertDelegate

extension ColorPaletteDetailViewModel: PaletteRenameAlertDelegate {
    func currentTextFieldText() -> String? { repository.palette.name }
    
    func alert(_ alert: UIAlertController, didRenameWith paletteName: String?) {
        do {
            try repository.renamePalette(paletteName).get()
            delegate?.reloadData()
        } catch {
            print(error)
        }
    }
    
    func alertDidCancel(_ alert: UIAlertController) {
        deletingIndexPath = nil
    }
}

// MARK: - PaletteDeleteAlertDelegate

extension ColorPaletteDetailViewModel: PaletteDeleteAlertDelegate {
    func alertDidConfirmDeletion(_ alert: UIAlertController) {
        guard let deletingIndexPath = deletingIndexPath else { return }
        do {
            try repository.removeColor(atIndex: deletingIndexPath.row).get()
            cellData.remove(at: deletingIndexPath.row)
            tableDelegate?.performTableViewUpdate(.delete([deletingIndexPath]), with: .top)
            delegate?.reloadData()
        } catch {
            print(error)
        }
        self.deletingIndexPath = nil
    }
}

// MARK: - Associated types / Export

enum ColorPaletteExportType: String {
    case swift, json, png, svg
    var identifier: String { rawValue }
}

// MARK: Action types

enum ColorPaletteDetailAction: DSActionType {
    case createColor
    case importColor
    case editColor(indexPath: IndexPath)
    case deleteColor(indexPath: IndexPath)
    case exportPalette(type: ColorPaletteExportType)
    case renamePalette
    
    var identifier: String {
        switch self {
        case .createColor: return "palette/add_color/create"
        case .importColor: return "palette/add_color/import"
        case .editColor(let indexPath): return "palette/edit_color/\(indexPath.row)"
        case .deleteColor(let indexPath): return "palette/delete_color/\(indexPath.row)"
        case .exportPalette(let exportType): return "palette/export/" + exportType.identifier
        case .renamePalette: return "palette/rename"
        }
    }
}

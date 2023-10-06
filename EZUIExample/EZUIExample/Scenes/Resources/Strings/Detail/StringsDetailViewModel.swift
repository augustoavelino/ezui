//
//  StringsDetailViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

protocol StringsDetailCellDataProtocol {
    var key: String { get }
    var value: String { get }
}

protocol StringsDetailViewModelProtocol: DSViewModelProtocol where ActionType == StringsDetailAction {
    associatedtype CellData: StringsDetailCellDataProtocol
    
    func paletteName() -> String
    func canRenameStringsFile(_ newName: String?) -> Bool
    func renameStringsFile(_ newName: String?) -> Result<Void, Error>
    
    func addString(key: String, value: String) -> Result<DSTableViewUpdate, Error>
    func fetchData() -> Result<Void, Error>
    func deleteString(atIndexPath indexPath: IndexPath) -> Result<Void, Error>
    func startEditing(atIndexPath indexPath: IndexPath) -> CellData?
    func editString(key newKey: String?, value newValue: String?) -> Result<DSTableViewUpdate, Error>
    
    func isListEmpty() -> Bool
    func numberOfSections() -> Int
    func numberOfCells(inSection section: Int) -> Int
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData?
    func isCellExpanded(atIndexPath indexPath: IndexPath) -> Bool
    func didSelectCell(atIndexPath indexPath: IndexPath) -> Result<DSTableViewUpdate, Error>
    
    func didTapExportStringsButton() -> Result<URL, Error>
    func didTapExportSwiftButton() -> Result<URL, Error>
    func didTapExportJSONButton() -> Result<URL, Error>
}

class StringsDetailViewModel: DSViewModel<StringsDetailAction>, StringsDetailViewModelProtocol {
    typealias CellData = StringsDetailCellData
    
    // MARK: Properties
    
    let repository: StringsDetailRepoProtocol
    weak var coordinator: StringsCoordinatorProtocol?
    
    var editingIndexPath: IndexPath?
    var cellData: [CellData] = []
    var expandedIndexPaths: [IndexPath] = []
    let availableLabelWidth = UIScreen.main.bounds.width - 78.0
    
    // MARK: - Life cycle
    
    init(repository: StringsDetailRepoProtocol, coordinator: StringsCoordinatorProtocol) {
        self.repository = repository
        self.coordinator = coordinator
    }
    
    // MARK: - StringsDetailViewModelProtocol
    
    func paletteName() -> String {
        return repository.stringsFile.name ?? ""
    }
    
    func canRenameStringsFile(_ newName: String?) -> Bool {
        guard let newName = newName, !newName.isEmpty else { return false }
        return newName != paletteName()
    }
    
    func renameStringsFile(_ newName: String?) -> Result<Void, Error> {
        do {
            try repository.renameStringsFile(newName).get()
            return .success(())
        } catch {
            print("🛑 StringsDetail: " + error.localizedDescription)
            return .failure(error)
        }
    }
    
    // MARK: CRUD
    
    func addString(key: String, value: String) -> Result<DSTableViewUpdate, Error> {
        do {
            let itemRow = try repository.addString(key: key, value: parseStringValueForBusiness(value)).get()
            try fetchData().get()
            return .success(.insert([IndexPath(row: itemRow, section: 0)]))
        } catch {
            print("🛑 StringsDetail: " + error.localizedDescription)
            return .failure(error)
        }
    }
    
    func fetchData() -> Result<Void, Error> {
        do {
            let data = try repository.fetchStringList().get()
            cellData = data.compactMap { parseString($0) }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteString(atIndexPath indexPath: IndexPath) -> Result<Void, Error> {
        do {
            try repository.removeString(atIndex: indexPath.row).get()
            return fetchData()
        } catch {
            print("🛑 StringsDetail: " + error.localizedDescription)
            return .failure(error)
        }
    }
    
    func startEditing(atIndexPath indexPath: IndexPath) -> CellData? {
        guard indexPath.row < cellData.count else { return nil }
        editingIndexPath = indexPath
        let dataForEditing = cellData[indexPath.row]
        let valueForEditing = parseStringValueForEditing(dataForEditing.value)
        return CellData(key: dataForEditing.key, value: valueForEditing)
    }
    
    func editString(key newKey: String?, value newValue: String?) -> Result<DSTableViewUpdate, Error> {
        guard let indexPath = editingIndexPath else { return .success(.none) }
        guard let key = newKey, !key.isEmpty,
              let value = newValue, !value.isEmpty else { return .failure(NSError(domain: "StringEdit", code: 1002, localizedDescription: "Key and value cannot be empty")) }
        do {
            try repository.editString(atIndex: indexPath.row, key: key, value: parseStringValueForBusiness(value)).get()
            try fetchData().get()
            editingIndexPath = nil
            return .success(.reloadData)
        } catch {
            editingIndexPath = nil
            return .failure(error)
        }
    }
    
    func didTapExportStringsButton() -> Result<URL, Error> {
        return repository.generateStringsFileSourceFile()
    }
    
    func didTapExportSwiftButton() -> Result<URL, Error> {
        return repository.generateStringsFileSwiftFile()
    }
    
    func didTapExportJSONButton() -> Result<URL, Error> {
        return repository.generateStringsFileJSONFile()
    }
    
    // MARK: Data
    
    func isListEmpty() -> Bool {
        return cellData.isEmpty
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfCells(inSection section: Int) -> Int {
        return cellData.count
    }
    
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData? {
        guard indexPath.row < cellData.count else { return nil }
        return cellData[indexPath.row]
    }
    
    func isCellExpanded(atIndexPath indexPath: IndexPath) -> Bool {
        return expandedIndexPaths.contains(indexPath)
    }
    
    func didSelectCell(atIndexPath indexPath: IndexPath) -> Result<DSTableViewUpdate, Error> {
        guard indexPath.row < cellData.count else { return .failure(NSError(domain: "", code: 1001, localizedDescription: "")) }
        guard cellData[indexPath.row].value.count > 89 else { return .success(.none) }
        toggleIndexPath(indexPath)
        return .success(.reload([indexPath]))
    }
    
    func toggleIndexPath(_ indexPath: IndexPath) {
        if isCellExpanded(atIndexPath: indexPath) {
            expandedIndexPaths.removeAll(where: { $0 == indexPath })
        } else {
            expandedIndexPaths.append(indexPath)
        }
    }
    
    func parseString(_ string: StringsFileString) -> CellData? {
        guard let stringKey = string.key,
              let stringValue = string.value else { return nil }
        return StringsDetailCellData(key: stringKey, value: parseStringValueForDisplay(stringValue))
    }
    
    func parseStringValueForDisplay(_ value: String) -> String {
        return value
    }
    
    func parseStringValueForEditing(_ value: String) -> String {
        var resultValue = value
        for escapedSequence in ParserEscapeSequences.allCases {
            resultValue = resultValue.replacingOccurrences(
                of: escapedSequence.replacementValue,
                with: escapedSequence.displayValue
            )
        }
        return resultValue
    }
    
    func parseStringValueForBusiness(_ value: String) -> String {
        var resultValue = value
        for escapedSequence in ParserEscapeSequences.allCases {
            resultValue = resultValue.replacingOccurrences(
                of: escapedSequence.displayValue,
                with: escapedSequence.replacementValue
            )
        }
        return resultValue
    }
    
    enum ParserEscapeSequences: String, CaseIterable {
        case nullCharacter = "\0"
        case backslash = "\\"
        case horizontalTab = "\t"
        case lineBreak = "\n"
        case carriageReturn = "\r"
        case quotationMark = "\""
        case apostrophe = "\'"
        case quotationMarkIOSKeyboard = "“"
        
        var displayValue: String { rawValue }
        var replacementValue: String {
            switch self {
            case .nullCharacter: return "\\0"
            case .backslash: return "\\\\"
            case .horizontalTab: return "\\t"
            case .lineBreak: return "\\n"
            case .carriageReturn: return "\\r"
            case .quotationMark, .quotationMarkIOSKeyboard: return "\\\""
            case .apostrophe: return "\\'"
            }
        }
    }
}

enum StringsDetailAction: DSActionType {
    var identifier: String { "" }
}

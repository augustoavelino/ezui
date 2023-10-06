//
//  StringsListViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

protocol StringsListCellDataProtocol {
    var name: String { get }
    var dateCreatedText: String { get }
    var dateUpdatedText: String { get }
}

protocol StringsListViewModelProtocol: DSViewModelProtocol where ActionType == StringsListAction {
    associatedtype CellData: StringsListCellDataProtocol
    
    func createStringsFile(name: String?) -> Result<Void, Error>
    func fetchData() -> Result<Void, Error>
    func renameStringsFile(atIndexPath indexPath: IndexPath, newName: String?) -> Result<Void, Error>
    func deleteStringsFile(atIndexPath indexPath: IndexPath) -> Result<Void, Error>
    func isListEmpty() -> Bool
    func numberOfSections() -> Int
    func numberOfCells(inSection section: Int) -> Int
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData?
    func didSelectCell(atIndexPath indexPath: IndexPath)
}

class StringsListViewModel: DSViewModel<StringsListAction>, StringsListViewModelProtocol {
    typealias CellData = StringsListCellData
    
    // MARK: Properties
    
    let repository: StringsListRepoProtocol
    weak var coordinator: StringsCoordinatorProtocol?
    var tableDelegate: DSTableViewModelDelegate? { delegate as? DSTableViewModelDelegate }
    
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm - dd/MM"
        return formatter
    }()
    
    var cellData: [CellData] = []
    
    // MARK: - Life cycle
    
    init(
        repository: StringsListRepoProtocol,
        coordinator: StringsCoordinatorProtocol
    ) {
        self.repository = repository
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator?.performRoute(.back, animated: true)
    }
    
    // MARK: - CRUD
    
    func createStringsFile(name: String?) -> Result<Void, Error> {
        do {
            let stringsFile = try repository.createStringsFile(named: name).get()
            return .success(navigateToDetail(stringsFile: stringsFile))
        } catch {
            return .failure(error)
        }
    }
    
    func fetchData() -> Result<Void, Error> {
        do {
            let data = try repository.fetchStringsFileList().get()
            cellData = data.compactMap { parseStringsFile($0) }
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func renameStringsFile(atIndexPath indexPath: IndexPath, newName: String?) -> Result<Void, Error> {
        do {
            try repository.renameStringsFile(atIndex: indexPath.row, newName: newName).get()
            try fetchData().get()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func deleteStringsFile(atIndexPath indexPath: IndexPath) -> Result<Void, Error> {
        do {
            try repository.removeStringsFile(atIndex: indexPath.row).get()
            return fetchData()
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: - Data
    
    func isListEmpty() -> Bool { cellData.isEmpty }
    func numberOfSections() -> Int { 1 }
    func numberOfCells(inSection section: Int) -> Int { cellData.count }
    
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData? {
        guard indexPath.row < cellData.count else { return nil }
        return cellData[indexPath.row]
    }
    
    // MARK: - Actions
    
    func didSelectCell(atIndexPath indexPath: IndexPath) {
        do {
            let stringsFile = try repository.stringsFile(atIndex: indexPath.row).get()
            navigateToDetail(stringsFile: stringsFile)
        } catch {
            print("🛑 " + error.localizedDescription)
        }
    }
    
    // MARK: - Navigation
    
    func navigateToDetail(stringsFile: StringsFile) {
        coordinator?.performRoute(.detail(stringsFile: stringsFile), animated: true)
    }
    
    // MARK: - Parsing
    
    func parseStringsFile(_ stringsFile: StringsFile) -> CellData {
        var dateCreatedText = "Created: "
        var dateUpdatedText = "Updated: "
        if let dateCreated = stringsFile.dateCreated {
            dateCreatedText += dateFormatter.string(from: dateCreated)
        }
        if let dateUpdated = stringsFile.dateUpdated {
            dateUpdatedText += dateFormatter.string(from: dateUpdated)
        }
        return StringsListCellData(
            name: stringsFile.name ?? "Untitled",
            dateCreatedText: dateCreatedText,
            dateUpdatedText: dateUpdatedText
        )
    }
}

enum StringsListAction: DSActionType {
    var identifier: String { "" }
}

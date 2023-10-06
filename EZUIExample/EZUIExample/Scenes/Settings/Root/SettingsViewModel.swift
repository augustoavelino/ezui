//
//  SettingsViewModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 17/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI
import UIKit

// MARK: Action

enum SettingsAction: DSActionType {
    case renameAuthor
    case sourceMenu
    
    var identifier: String {
        switch self {
        case .renameAuthor: return "settings/rename_author"
        case .sourceMenu: return "settings/source_menu"
        }
    }
}

// MARK: - Cell data protocol

protocol SettingsCellDataProtocol {
    var text: String { get }
    var secondaryText: String? { get }
}

// MARK: - Cell data placeholder
// TODO: Encontrar forma de se livrar disso

class SettingsCellData: SettingsCellDataProtocol {
    var text: String = ""
    var secondaryText: String?
    
    init(text: String, secondaryText: String? = nil) {
        self.text = text
        self.secondaryText = secondaryText
    }
}

// MARK: - Protocol

protocol SettingsViewModelProtocol: DSViewModelProtocol where ActionType == SettingsAction {
    associatedtype CellData: SettingsCellDataProtocol
    func setAuthor(name: String?) -> Result<DSTableViewUpdate, Error>
    func fetchData() -> Result<DSTableViewUpdate, Error>
    func numberOfSections() -> Int
    func numberOfCells(inSection section: Int) -> Int
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData?
    func selectedIndexPath() -> Result<IndexPath?, Error>
    func title(forSection section: Int) -> String?
    func canSelectCell(atIndexPath indexPath: IndexPath) -> Bool
    func didSelectCell(atIndexPath indexPath: IndexPath, completion: @escaping (Result<DSTableViewUpdate, Error>) -> Void)
    func textForTableFooter() -> String?
}

// MARK: - View model

class SettingsViewModel: DSViewModel<SettingsAction>, SettingsViewModelProtocol {
    typealias CellData = SettingsCellData
    class SectionData {
        var title: String
        var cellData: [CellData]
        
        init(title: String, cellData: [CellData]) {
            self.title = title
            self.cellData = cellData
        }
    }
    
    // MARK: Properties
    
    let defaultAuthorName = "Author"
    
    let authorSection = 0
    let tintSection = 1
    
    let repository: SettingsRepoProtocol
    weak var coordinator: SettingsCoordinatorProtocol?
    weak var tableDelegate: DSTableViewModelDelegate? { delegate as? DSTableViewModelDelegate }
    
    var sectionData: [SectionData] = []
    var authorCompletion: ((Result<DSTableViewUpdate, Error>) -> Void)?
    
    // MARK: - Life cycle
    
    init(repository: SettingsRepoProtocol, coordinator: SettingsCoordinatorProtocol) {
        self.repository = repository
        self.coordinator = coordinator
    }
    
    deinit {
        coordinator?.performRoute(.back, animated: true)        
    }
    
    // MARK: - Action handling
    
    override func performAction(_ actionType: SettingsAction) {
        switch actionType {
        case .renameAuthor: return
        case .sourceMenu: coordinator?.performRoute(.sourceMenu, animated: true)
        }
    }
    
    // MARK: - Data handling
    
    func fetchData() -> Result<DSTableViewUpdate, Error> {
        do {
            _ = try fetchAuthorName().get()
            _ = try fetchTintData().get()
            return .success(.reloadData)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchAuthorName() -> Result<DSTableViewUpdate, Error> {
        do {
            let authorName = try repository.getAuthorName().get()
            let cellData = SettingsAuthorNameCellData(
                authorName: authorName ?? defaultAuthorName,
                isPrimary: authorName != nil
            )
            sectionData.removeAll(where: { $0.cellData is [SettingsAuthorNameCellData] })
            sectionData.insert(SectionData(title: "author", cellData: [cellData]), at: authorSection)
            return .success(.reconfigure(indexPaths(forSection: authorSection)))
        } catch {
            return .failure(error)
        }
    }
    
    func setAuthor(name: String?) -> Result<DSTableViewUpdate, Error> {
        do {
            try repository.setAuthorName(name).get()
            return .success(.reconfigure(indexPaths(forSection: authorSection)))
        } catch {
            return .failure(error)
        }
    }
    
    func fetchTintData() -> Result<DSTableViewUpdate, Error> {
        do {
            let result = try repository.getAvailableTintColors().get()
            let cellData = result.compactMap { SettingsTintCellData(color: $0.color, text: $0.text, secondaryText: nil) }
            sectionData.removeAll(where: { $0.cellData is [SettingsTintCellData] })
            sectionData.insert(SectionData(title: "tint color", cellData: cellData), at: tintSection)
            return .success(.reconfigure(indexPaths(forSection: tintSection)))
        } catch {
            return .failure(error)
        }
    }
    
    // MARK: Data source
    
    func isListEmpty() -> Bool { sectionData.isEmpty }
    func numberOfSections() -> Int { sectionData.count }
    func numberOfCells(inSection section: Int) -> Int {
        guard section < sectionData.count else { return 0 }
        return sectionData[section].cellData.count
    }
    
    func dataForCell(atIndexPath indexPath: IndexPath) -> CellData? {
        guard indexPath.section < sectionData.count,
              indexPath.row < sectionData[indexPath.section].cellData.count else { return nil }
        return sectionData[indexPath.section].cellData[indexPath.row]
    }
    
    func title(forSection section: Int) -> String? {
        guard section < sectionData.count else { return nil }
        return sectionData[section].title
    }
    
    // MARK: Cell selection
    
    func selectedIndexPath() -> Result<IndexPath?, Error> {
        do {
            guard let row = try repository.getSelectedTintIndex().get() else { return .success(nil) }
            return .success(IndexPath(row: row, section: tintSection))
        } catch {
            return .failure(error)
        }
    }
    
    func canSelectCell(atIndexPath indexPath: IndexPath) -> Bool {
        return indexPath.section == tintSection
    }
    
    func didSelectCell(atIndexPath indexPath: IndexPath, completion: @escaping (Result<DSTableViewUpdate, Error>) -> Void) {
        switch indexPath.section {
        case authorSection: didSelectAuthorCell(completion: completion)
        case tintSection: didSelectTintCell(atRow: indexPath.row, completion: completion)
        default: completion(.success(.none))
        }
    }
    
    func didSelectAuthorCell(completion: @escaping (Result<DSTableViewUpdate, Error>) -> Void) {
        authorCompletion = completion
        coordinator?.performRoute(.authorNameAlert(self), animated: true)
    }
    
    func didSelectTintCell(atRow row: Int, completion: @escaping (Result<DSTableViewUpdate, Error>) -> Void) {
        do {
            let didSelect = try repository.setApplicationTintColor(atIndex: row).get()
            if didSelect {
                completion(.success(.none))
            } else {
                completion(.success(.deselect(IndexPath(row: row, section: tintSection))))
            }
        } catch {
            completion(.failure(error))
        }
    }
    
    func indexPaths(forSection section: Int) -> [IndexPath] {
        guard section < sectionData.count else { return [] }
        return (0..<sectionData[section].cellData.count).map { IndexPath(row: $0, section: section) }
    }
    
    func textForTableFooter() -> String? {
        let footerContent = String.appStringFormatted(.settings(.version), "EZUI", getLibVersion())  + "\n"
        + String.appStringFormatted(.settings(.version), "EZUI Utility", getAppVersion()) + "\n"
        + String.appString(.settings(.author))
        return footerContent
    }
    
    func getLibVersion() -> String {
        guard let libVersion = Bundle(identifier: "com.augustoavelino.EZUI")?.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "1.0.0"
        }
        return libVersion
    }
    
    func getAppVersion() -> String {
        guard let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
            return "1.0.0"
        }
        return appVersion
    }
}

// MARK: - SettingsNameAlertDelegate

extension SettingsViewModel: SettingsNameAlertDelegate {
    func alertDefaultName() -> String? {
        return try? repository.getAuthorName().get()
    }
    
    func alert(_ alert: UIAlertController, didFinishWith authorName: String?) {
        do {
            try repository.setAuthorName(authorName).get()
            let result = try fetchAuthorName().get()
            authorCompletion?(.success(result))
            authorCompletion = nil
        } catch {
            authorCompletion?(.failure(error))
            authorCompletion = nil
        }
    }
}

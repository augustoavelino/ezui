//
//  StringsListRepository.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import CoreData

protocol StringsListRepoProtocol {
    func createStringsFile(named name: String?) -> Result<StringsFile, Error>
    func fetchStringsFileList() -> Result<[StringsFile], Error>
    func stringsFile(atIndex itemIndex: Int) -> Result<StringsFile, Error>
    func renameStringsFile(atIndex itemIndex: Int, newName: String?) -> Result<Void, Error>
    func removeStringsFile(atIndex itemIndex: Int) -> Result<Void, Error>
}

class StringsListRepository: StringsListRepoProtocol {
    var stringsFileList: [StringsFile] = []
    
    func createStringsFile(named name: String?) -> Result<StringsFile, Error> {
        guard let name = name, !name.isEmpty else { return .failure(error(.createEmptyName)) }
        do {
            let stringsFile = try AppCoreDataManager.shared.create(StringsFile.self) { stringsFile in
                stringsFile.uuid = UUID().uuidString
                stringsFile.dateCreated = Date()
                stringsFile.dateUpdated = Date()
                stringsFile.name = name
            }.get()
            stringsFileList.append(stringsFile)
            stringsFileList = stringsFileList.sorted()
            return .success(stringsFile)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchStringsFileList() -> Result<[StringsFile], Error> {
        guard !stringsFileList.isEmpty else {
            do {
                stringsFileList = try AppCoreDataManager.shared.fetch(StringsFile.self).get().sorted()
            } catch {
                print(error)
            }
            return .success(stringsFileList)
        }
        return .success(stringsFileList)
    }
    
    func stringsFile(atIndex itemIndex: Int) -> Result<StringsFile, Error> {
        guard itemIndex < stringsFileList.count else { return .failure(error(.indexOutOfBounds)) }
        return .success(stringsFileList[itemIndex])
    }
    
    func renameStringsFile(atIndex itemIndex: Int, newName: String?) -> Result<Void, Error> {
        guard let newName = newName, !newName.isEmpty else { return .failure(error(.createEmptyName)) }
        do {
            let stringsFile = try stringsFile(atIndex: itemIndex).get()
            stringsFile.name = newName
            stringsFile.dateUpdated = Date()
            AppCoreDataManager.shared.saveIfChanged()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func removeStringsFile(atIndex itemIndex: Int) -> Result<Void, Error> {
        guard itemIndex < stringsFileList.count else { return .failure(error(.indexOutOfBounds)) }
        let item = stringsFileList.remove(at: itemIndex)
        do {
            try removeStrings(in: item)
            try AppCoreDataManager.shared.delete(item).get()
            _ = try fetchStringsFileList().get()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func removeStrings(in stringsFile: StringsFile) throws {
        guard let strings = stringsFile.strings?.compactMap({ $0 as? StringsFileString }) else { throw error(.unexpected) }
        for string in strings {
            try AppCoreDataManager.shared.delete(string).get()
        }
    }
    
    func sortItems(_ itemsToSort: [StringsFile]) -> [StringsFile] {
        return itemsToSort.sorted()
        // TODO: Implementar função de ordenação
//        var sortedItems: [StringsFile]
//        switch sortType {
//        case .dateCreated: sortedItems = sortByDateCreated(itemsToSort)
//        case .name: sortedItems = sortByName(itemsToSort)
//        default: sortedItems = sortByDateUpdated(itemsToSort)
//        }
//        if sortOrder == .descending { return sortedItems.reversed() }
//        return sortedItems
    }
}

// MARK: - AppErrorSource

extension StringsListRepository: AppErrorSource {
    enum AppErrorType: Int, AppErrorProtocol {
        case createEmptyName = 1001
        case renameEmptyName
        case indexOutOfBounds
        case unableToCreateUUID
        case unexpected
        
        var domain: String { "StringsListBusinessModel" }
        var code: Int { rawValue }
        var message: String {
            switch self {
            case .createEmptyName, .renameEmptyName: return "Name cannot be empty"
            case .indexOutOfBounds: return "Index out of bounds"
            case .unableToCreateUUID: return "Could not create UUID for strings file"
            case .unexpected: return "An unexpected error has occurred"
            }
        }
    }
}

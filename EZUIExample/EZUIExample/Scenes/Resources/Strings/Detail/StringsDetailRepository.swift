//
//  StringsDetailRepository.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

protocol StringsDetailRepoProtocol {
    var stringsFile: StringsFile { get }
    
    func addString(key: String, value: String) -> Result<Int, Error>
    func fetchStringList() -> Result<[StringsFileString], Error>
    func color(atIndex itemIndex: Int) -> Result<StringsFileString, Error>
    func renameStringsFile(_ newName: String?) -> Result<Void, Error>
    func editString(atIndex itemIndex: Int, key: String, value: String) -> Result<Void, Error>
    func removeString(atIndex colorIndex: Int) -> Result<Void, Error>
    func generateStringsFileSourceFile() -> Result<URL, Error>
    func generateStringsFileSwiftFile() -> Result<URL, Error>
    func generateStringsFileJSONFile() -> Result<URL, Error>
}

class StringsDetailRepository: StringsDetailRepoProtocol {
    
    // MARK: Properties
    
    let stringsFile: StringsFile
    var stringItems: [StringsFileString] = []
    
    // MARK: - Life cycle
    
    init(stringsFile: StringsFile) {
        self.stringsFile = stringsFile
    }
    
    // MARK: - CRUD
    
    func addString(key: String, value: String) -> Result<Int, Error> {
        do {
            let newStringsFileString = try AppCoreDataManager.shared.create(StringsFileString.self, handler: { [weak self] string in
                guard let self = self else { return }
                string.uuid = UUID().uuidString
                string.key = key
                string.value = value
                string.stringsFile = self.stringsFile
            }).get()
            stringItems.append(newStringsFileString)
            stringItems = stringItems.sorted(by: {
                guard let lKey = $0.key, !lKey.isEmpty,
                      let rKey = $1.key, !rKey.isEmpty else { return false }
                return lKey.lowercased() < rKey.lowercased()
            })
            try updateStringsFileDate().get()
            guard let colorIndex = stringItems.firstIndex(of: newStringsFileString) else { return .failure(error(.unexpected)) }
            return .success(colorIndex)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchStringList() -> Result<[StringsFileString], Error> {
        do {
            let predicate = NSPredicate(format: "stringsFile == %@", stringsFile)
            stringItems = try AppCoreDataManager.shared.fetch(StringsFileString.self, predicate: predicate).get().sorted(by: {
                guard let lKey = $0.key, !lKey.isEmpty,
                      let rKey = $1.key, !rKey.isEmpty else { return false }
                return lKey.lowercased() < rKey.lowercased()
            })
            return .success(stringItems)
        } catch {
            return .failure(error)
        }
    }
    
    func color(atIndex itemIndex: Int) -> Result<StringsFileString, Error> {
        guard itemIndex < stringItems.count else { return .failure(error(.indexOutOfBounds)) }
        return .success(stringItems[itemIndex])
    }
    
    func editString(atIndex itemIndex: Int, key: String, value: String) -> Result<Void, Error> {
        guard itemIndex < stringItems.count else { return .failure(error(.indexOutOfBounds)) }
        let stringItem = stringItems[itemIndex]
        stringItem.key = key
        stringItem.value = value
        AppCoreDataManager.shared.saveIfChanged()
        do {
            _ = try fetchStringList().get()
            try updateStringsFileDate().get()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func renameStringsFile(_ newName: String?) -> Result<Void, Error> {
        guard let newName = newName, !newName.isEmpty else { return .failure(error(.emptyName)) }
        do {
            stringsFile.name = newName
            try updateStringsFileDate().get()
            AppCoreDataManager.shared.saveIfChanged()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func removeString(atIndex colorIndex: Int) -> Result<Void, Error> {
        guard colorIndex < stringItems.count else { return .failure(error(.indexOutOfBounds)) }
        let item = stringItems.remove(at: colorIndex)
        do {
            try AppCoreDataManager.shared.delete(item).get()
            _ = try fetchStringList().get()
            try updateStringsFileDate().get()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func generateStringsFileSourceFile() -> Result<URL, Error> {
        let composer = StringsFileStringsComposer(stringsFile: stringsFile, strings: stringItems)
        return composer.writeToFile()
    }
    
    func generateStringsFileSwiftFile() -> Result<URL, Error> {
        return .failure(error(.unexpected))
    }
    
    func generateStringsFileJSONFile() -> Result<URL, Error> {
        return .failure(error(.unexpected))
    }
    
    // MARK: - StringsFile update
    
    func updateStringsFileDate() -> Result<Void, Error> {
        stringsFile.dateUpdated = Date()
        AppCoreDataManager.shared.saveIfChanged()
        return .success(())
    }
}

// MARK: - AppErrorSource

extension StringsDetailRepository: AppErrorSource {
    enum AppErrorType: Int, AppErrorProtocol {
        case indexOutOfBounds = 1001
        case emptyName
        case unexpected
        
        var domain: String { "StringsDetailBusinessModel" }
        var code: Int { rawValue }
        var message: String {
            switch self {
            case .indexOutOfBounds: return "Index out of bounds"
            case .emptyName: return "Name cannot be empty"
            case .unexpected: return "An unexpected error has occurred"
            }
        }
    }
}

//
//  IconographyBusinessModel.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 12/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

struct IconographyItem {
    var imageName: String
}

protocol IconographyRepoProtocol {
    func fetchItems() -> Result<[IconographyItem], Error>
    func fetchFavorites() -> Result<[IconographyItem], Error>
    func toggleFavoriteState(forItemNamed itemName: String) -> Result<Void, Error>
    func getSavedColorMode() -> Result<String, Error>
    func saveColorMode(_ colorMode: String)
}

class IconographyRepository: IconographyRepoProtocol {
    
    // MARK: Keys
    
    var favoriteNames: [String] = []
    let jsonFileName = "Iconography"
    var itemData: [IconographyItem] = []
    
    // MARK: - IconographyRepoProtocol
    
    func fetchItems() -> Result<[IconographyItem], Error> {
        guard itemData.isEmpty else { return .success(itemData) }
        do {
            let jsonItems = try fetchItemsFromJSON().get()
            itemData = jsonItems
            return .success(jsonItems)
        } catch {
            return .failure(error)
        }
    }
    
    func fetchFavorites() -> Result<[IconographyItem], Error> {
        if let savedFavorites = AppDefaultsManager.shared.value(forKey: .iconographyFavorites) as? [String] {
            favoriteNames = savedFavorites
        }
        return .success(favoriteNames.compactMap(IconographyItem.init))
    }
    
    func toggleFavoriteState(forItemNamed itemName: String) -> Result<Void, Error> {
        let isFavorite = favoriteNames.contains(where: { $0 == itemName })
        if isFavorite {
            favoriteNames.removeAll(where: { $0 == itemName })
        } else {
            favoriteNames.append(itemName)
        }
        saveFavorites()
        return .success(())
    }
    
    func getSavedColorMode() -> Result<String, Error> {
        guard let styleMode = AppDefaultsManager.shared.string(forKey: .iconographyColorMode) else {
            return .failure(error(.noSavedColorMode))
        }
        return .success(styleMode)
    }
    
    func saveColorMode(_ colorMode: String) {
        AppDefaultsManager.shared.set(colorMode, forKey: .iconographyColorMode)
    }
    
    // MARK: - Helpers
    
    func fetchItemsFromJSON() -> Result<[IconographyItem], Error> {
        guard let url = Bundle.main.url(forResource: jsonFileName, withExtension: "json") else {
            return .failure(error(.noJSONFile))
        }
        do {
            let fileData = try Data(contentsOf: url)
            guard let imageNames = try JSONSerialization.jsonObject(with: fileData, options: []) as? [String] else {
                return .failure(error(.corruptedData))
            }
            return .success(imageNames.compactMap(IconographyItem.init))
        } catch {
            return .failure(error)
        }
    }
    
    func saveFavorites() {
        AppDefaultsManager.shared.set(favoriteNames, forKey: .iconographyFavorites)
    }
}

// MARK: - AppErrorSource

extension IconographyRepository: AppErrorSource {
    enum AppErrorType: Int, AppErrorProtocol {
        case noSavedColorMode = 1001
        case noJSONFile
        case corruptedData
        case unexpected
        
        var domain: String { "IconographyBusinessModel" }
        var code: Int { rawValue }
        var message: String {
            switch self {
            case .noSavedColorMode: return "Could not load any saved iconography color mode"
            case .noJSONFile: return "Failed to load iconography JSON"
            case .corruptedData: return "Iconography JSON data is corrupted"
            case .unexpected: return "An unexpected error has occurred"
            }
        }
    }
}

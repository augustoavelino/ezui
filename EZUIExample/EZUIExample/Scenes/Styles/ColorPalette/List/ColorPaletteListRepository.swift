//
//  ColorPaletteListRepository.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 14/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import CoreData

enum ColorPaletteListSortOrder: String {
    case ascending, descending
    var identifier: String { rawValue }
}

enum ColorPaletteListSortType: String {
    case `default`, dateUpdated, dateCreated, name
    var identifier: String { rawValue }
}

protocol ColorPaletteListRepoProtocol {
    func currentSortType() -> ColorPaletteListSortType
    func currentSortOrder() -> ColorPaletteListSortOrder
    func createPalette(named name: String?) -> Result<(Palette, Int), Error>
    func fetchPaletteList() -> Result<[Palette], Error>
    func palette(atIndex itemIndex: Int) -> Result<Palette, Error>
    func applySort(type: ColorPaletteListSortType) -> Result<Void, Error>
    func applySort(order: ColorPaletteListSortOrder) -> Result<Void, Error>
    func renamePalette(atIndex itemIndex: Int, newName: String?) -> Result<(Palette, Int), Error>
    func removePalette(atIndex itemIndex: Int) -> Result<Void, Error>
}

class ColorPaletteListRepository: ColorPaletteListRepoProtocol {
    var paletteList: [Palette] = []
    var sortType: ColorPaletteListSortType = .default
    var sortOrder: ColorPaletteListSortOrder = .descending
    
    func currentSortType() -> ColorPaletteListSortType { sortType }
    func currentSortOrder() -> ColorPaletteListSortOrder { sortOrder }
    
    func createPalette(named name: String?) -> Result<(Palette, Int), Error> {
        guard let name = name, !name.isEmpty else { return .failure(error(.createEmptyName)) }
        do {
            let palette = try AppCoreDataManager.shared.create(Palette.self) { palette in
                palette.id = UUID().uuidString
                palette.dateCreated = Date()
                palette.dateUpdated = Date()
                palette.name = name
            }.get()
            paletteList.append(palette)
            paletteList = sortItems(paletteList)
            
            guard let itemIndex = paletteList.firstIndex(of: palette) else {
                return .failure(error(.unexpected))
            }
            return .success((palette, itemIndex))
        } catch {
            return .failure(error)
        }
    }
    
    func fetchPaletteList() -> Result<[Palette], Error> {
        guard !paletteList.isEmpty else {
            do {
                let resultItems = try AppCoreDataManager.shared.fetch(Palette.self).get()
                paletteList = sortItems(resultItems)
                return .success(paletteList)
            } catch {
                return .failure(error)
            }
        }
        paletteList = sortItems(paletteList)
        return .success(paletteList)
    }
    
    func palette(atIndex itemIndex: Int) -> Result<Palette, Error> {
        guard itemIndex < paletteList.count else { return .failure(error(.indexOutOfBounds)) }
        return .success(paletteList[itemIndex])
    }
    
    func applySort(type: ColorPaletteListSortType) -> Result<Void, Error> {
        sortType = type
        return .success(())
    }
    
    func applySort(order: ColorPaletteListSortOrder) -> Result<Void, Error> {
        sortOrder = order
        return .success(())
    }
    
    func renamePalette(atIndex itemIndex: Int, newName: String?) -> Result<(Palette, Int), Error> {
        guard let newName = newName, !newName.isEmpty else { return .failure(error(.createEmptyName)) }
        do {
            let palette = try palette(atIndex: itemIndex).get()
            palette.name = newName
            palette.dateUpdated = Date()
            AppCoreDataManager.shared.saveIfChanged()
            guard let paletteIndex = paletteList.firstIndex(of: palette) else { return .failure(error(.unexpected)) }
            return .success((palette, paletteIndex))
        } catch {
            return .failure(error)
        }
    }
    
    func removePalette(atIndex itemIndex: Int) -> Result<Void, Error> {
        guard itemIndex < paletteList.count else { return .failure(error(.indexOutOfBounds)) }
        let item = paletteList.remove(at: itemIndex)
        do {
            try removeColors(in: item)
            try AppCoreDataManager.shared.delete(item).get()
            _ = try fetchPaletteList().get()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func removeColors(in palette: Palette) throws {
        guard let colors = palette.colors?.compactMap({ $0 as? PaletteColor }) else { throw error(.unexpected) }
        for color in colors {
            try AppCoreDataManager.shared.delete(color).get()
        }
    }
    
    func sortItems(_ itemsToSort: [Palette]) -> [Palette] {
        var sortedItems: [Palette]
        switch sortType {
        case .dateCreated: sortedItems = sortByDateCreated(itemsToSort)
        case .name: sortedItems = sortByName(itemsToSort)
        default: sortedItems = sortByDateUpdated(itemsToSort)
        }
        if sortOrder == .descending { return sortedItems.reversed() }
        return sortedItems
    }
    
    // Default
    func sortByDateUpdated(_ itemsToSort: [Palette]) -> [Palette] {
        return itemsToSort.sorted(by: { lPalette, rPalette in
            guard let lhs = lPalette.dateUpdated,
                  let rhs = rPalette.dateUpdated else { return true }
            return lhs < rhs
        })
    }
    
    func sortByDateCreated(_ itemsToSort: [Palette]) -> [Palette] {
        return itemsToSort.sorted(by: { lPalette, rPalette in
            guard let lhs = lPalette.dateCreated,
                  let rhs = rPalette.dateCreated else { return true }
            return lhs < rhs
        })
    }
    
    func sortByName(_ itemsToSort: [Palette]) -> [Palette] {
        return itemsToSort.sorted(by: { lPalette, rPalette in
            guard let lhs = lPalette.name?.lowercased(),
                  let rhs = rPalette.name?.lowercased() else { return true }
            return lhs < rhs
        })
    }
}

// MARK: - AppErrorSource

extension ColorPaletteListRepository: AppErrorSource {
    enum AppErrorType: Int, AppErrorProtocol {
        case createEmptyName = 1001
        case renameEmptyName
        case indexOutOfBounds
        case unableToCreateUUID
        case unexpected
        
        var domain: String { "ColorPaletteListRepository" }
        var code: Int { rawValue }
        var message: String {
            switch self {
            case .createEmptyName, .renameEmptyName: return "Name cannot be empty"
            case .indexOutOfBounds: return "Index out of bounds"
            case .unableToCreateUUID: return "Could not create UUID for palette"
            case .unexpected: return "An unexpected error has occurred"
            }
        }
    }
}

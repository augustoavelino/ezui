//
//  ColorPaletteDetailRepository.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 14/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

protocol ColorPaletteDetailRepoProtocol {
    var palette: Palette { get }
    
    func addColor(name: String, colorHex: Int) -> Result<(PaletteColor, Int), Error>
    func fetchColorList() -> Result<[PaletteColor], Error>
    func color(atIndex itemIndex: Int) -> Result<PaletteColor, Error>
    func renamePalette(_ newName: String?) -> Result<Void, Error>
    func editColor(atIndex itemIndex: Int, name: String, colorHex: Int) -> Result<Void, Error>
    func removeColor(atIndex colorIndex: Int) -> Result<Void, Error>
    func generatePaletteSwiftFile() -> Result<URL, Error>
    func generatePaletteJSONFile() -> Result<URL, Error>
    func generatePalettePNGFile() -> Result<URL, Error>
    func generatePaletteSVGFile() -> Result<URL, Error>
}

class ColorPaletteDetailRepository: ColorPaletteDetailRepoProtocol {
    
    // MARK: Properties
    
    let palette: Palette
    var colorItems: [PaletteColor] = []
    
    // MARK: - Life cycle
    
    init(palette: Palette) {
        self.palette = palette
    }
    
    // MARK: - CRUD
    
    func addColor(name: String, colorHex: Int) -> Result<(PaletteColor, Int), Error> {
        do {
            let newPaletteColor = try AppCoreDataManager.shared.create(PaletteColor.self, handler: { [weak self] paletteColor in
                guard let self = self else { return }
                paletteColor.id = UUID().uuidString
                paletteColor.name = name
                paletteColor.colorHex = Int64(colorHex)
                paletteColor.palette = self.palette
            }).get()
            colorItems.append(newPaletteColor)
            colorItems = sortItems(colorItems)
            try updatePaletteDate().get()
            guard let colorIndex = colorItems.firstIndex(of: newPaletteColor) else { return .failure(error(.unexpected)) }
            return .success((newPaletteColor, colorIndex))
        } catch {
            return .failure(error)
        }
    }
    
    func fetchColorList() -> Result<[PaletteColor], Error> {
        do {
            let predicate = NSPredicate(format: "palette == %@", palette)
            let resultItems = try AppCoreDataManager.shared.fetch(PaletteColor.self, predicate: predicate).get()
            colorItems = sortItems(resultItems)
            return .success(colorItems)
        } catch {
            return .failure(error)
        }
    }
    
    func color(atIndex itemIndex: Int) -> Result<PaletteColor, Error> {
        guard itemIndex < colorItems.count else { return .failure(error(.indexOutOfBounds)) }
        return .success(colorItems[itemIndex])
    }
    
    func renamePalette(_ newName: String?) -> Result<Void, Error> {
        guard let newName = newName, !newName.isEmpty else { return .failure(error(.emptyName)) }
        do {
            palette.name = newName
            try updatePaletteDate().get()
            AppCoreDataManager.shared.saveIfChanged()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func editColor(atIndex itemIndex: Int, name: String, colorHex: Int) -> Result<Void, Error> {
        guard itemIndex < colorItems.count else { return .failure(error(.indexOutOfBounds)) }
        let colorItem = colorItems[itemIndex]
        colorItem.name = name
        colorItem.colorHex = Int64(colorHex)
        AppCoreDataManager.shared.saveIfChanged()
        do {
            _ = try fetchColorList().get()
            try updatePaletteDate().get()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func removeColor(atIndex colorIndex: Int) -> Result<Void, Error> {
        guard colorIndex < colorItems.count else { return .failure(error(.indexOutOfBounds)) }
        let item = colorItems.remove(at: colorIndex)
        do {
            try AppCoreDataManager.shared.delete(item).get()
            _ = try fetchColorList().get()
            try updatePaletteDate().get()
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func generatePaletteSwiftFile() -> Result<URL, Error> {
        let composer = ColorPaletteSwiftComposer(palette: palette, paletteColors: colorItems)
        return composer.writeToFile()
    }
    
    func generatePaletteJSONFile() -> Result<URL, Error> {
        let composer = ColorPaletteJSONComposer(palette: palette, paletteColors: colorItems)
        return composer.writeToFile()
    }
    
    func generatePalettePNGFile() -> Result<URL, Error> {
        let composer = ColorPalettePNGComposer(palette: palette, paletteColors: colorItems)
        return composer.writeToFile()
    }
    
    func generatePaletteSVGFile() -> Result<URL, Error> {
        let composer = ColorPaletteSVGComposer(palette: palette, paletteColors: colorItems)
        return composer.writeToFile()
    }
    
    // MARK: - Palette update
    
    func updatePaletteDate() -> Result<Void, Error> {
        palette.dateUpdated = Date()
        AppCoreDataManager.shared.saveIfChanged()
        return .success(())
    }
    
    func sortItems(_ itemsToSort: [PaletteColor]) -> [PaletteColor] {
        return itemsToSort.sorted(by: {
            guard let lName = $0.name,
                  let rName = $1.name else { return false }
            return lName.lowercased() < rName.lowercased()
        })
    }
}

// MARK: - AppErrorSource

extension ColorPaletteDetailRepository: AppErrorSource {
    enum AppErrorType: Int, AppErrorProtocol {
        case indexOutOfBounds = 1001
        case emptyName
        case unexpected
        
        var domain: String { "ColorPaletteDetailRepository" }
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

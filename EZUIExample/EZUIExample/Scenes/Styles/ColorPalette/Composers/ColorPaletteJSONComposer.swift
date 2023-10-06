//
//  ColorPaletteJSONComposer.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

class ColorPaletteJSONComposer: JSONComposer {
    
    // MARK: Properties
    
    let palette: Palette
    let paletteColors: [PaletteColor]
    
    lazy var fileName: String = {
        guard let paletteName = palette.name else { return "ColorPalette" }
        return paletteName
    }()
    
    // MARK: - Life cycle
    
    init(palette: Palette, paletteColors: [PaletteColor]) {
        self.palette = palette
        self.paletteColors = paletteColors
        super.init()
        setupContent()
    }
    
    func setupContent() {
        setComponents(makeAllObjects())
    }
    
    func writeToFile(inDirectory directoryURL: URL = FileManager.default.temporaryDirectory) -> Result<URL, Error> {
        return writeToFile(named: fileName.upperCamelCased(), inDirectory: directoryURL)
    }
    
    // MARK: - Composing
    
    func makeAllObjects() -> [JSONComposerComponent] {
        var components: [JSONComposerComponent] = [.openArray, .lineBreak]
        for (index, color) in paletteColors.enumerated() {
            components.append(contentsOf: makeObject(for: color, addComma: index < paletteColors.count - 1))
        }
        components.append(contentsOf: [.closeArray, .lineBreak])
        return components
    }
    
    func makeObject(for color: PaletteColor, addComma: Bool) -> [JSONComposerComponent] {
        guard let colorName = color.name else { return [] }
        let colorHex = ColorFormatter(prefix: "#").stringFromInt(rgba: color.colorHex)
        var components: [JSONComposerComponent] = [
            .tab, .openObject, .lineBreak,
            .tab, .tab, .keyString(key: "name", value: colorName), .comma, .lineBreak,
            .tab, .tab, .keyString(key: "color", value: colorHex), .lineBreak,
            .tab, .closeObject,
        ]
        if addComma { components.append(.comma) }
        components.append(.lineBreak)
        return components
    }
}

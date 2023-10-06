//
//  ColorPaletteSwiftComposer.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 23/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

class ColorPaletteSwiftComposer: SwiftComposer {
    
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
        setHeader(makeHeader())
        addComponents(makeImportsSection())
        addComponents(makeEnumDeclaration())
        addComponents(makeAllConstants())
        addComponent(.endDeclaration)
    }
    
    func writeToFile(inDirectory directoryURL: URL = FileManager.default.temporaryDirectory) -> Result<URL, Error> {
        return writeToFile(named: fileName.upperCamelCased(), inDirectory: directoryURL)
    }
    
    // MARK: - Composing
    
    func makeHeader() -> SwiftComposerHeader {
        let date = Date()
        return SwiftComposerHeader(
            fileName: fileName.upperCamelCased(),
            project: "EZUI",
            author: "Augusto Avelino",
            date: AppDateFormatter.shared.string(from: date, format: "dd/MM/yy"),
            year: AppDateFormatter.shared.string(from: date, format: "yyyy")
        )
    }
    
    func makeImportsSection() -> [SwiftComposerComponent] {
        return [
            .importModule(moduleName: "EZUI"), .lineBreak,
            .importModule(moduleName: "UIKit"), .lineBreak,
        ]
    }
    
    func makeEnumDeclaration() -> [SwiftComposerComponent] {
        return [
            .lineBreak,
            .enumDeclaration(enumName: fileName.upperCamelCased()), .emptySpace, .beginDeclaration,
        ]
    }
    
    func makeAllConstants() -> [SwiftComposerComponent] {
        var components: [SwiftComposerComponent] = []
        for color in paletteColors {
            components.append(contentsOf: makeConstant(color: color))
        }
        return components
    }
    
    func makeConstant(color: PaletteColor) -> [SwiftComposerComponent] {
        let colorName = color.name ?? "undefined"
        let colorHex = ColorFormatter().stringFromInt(rgba: color.colorHex)
        return [.tab, .staticLetDeclaration(constantName: colorName.camelCased()), .assignValue, .uiColorRGBAInit(hexString: colorHex), .lineBreak]
    }
}

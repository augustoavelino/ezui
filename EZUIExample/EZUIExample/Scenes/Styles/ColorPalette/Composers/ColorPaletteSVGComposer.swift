//
//  ColorPaletteSVGComposer.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

class ColorPaletteSVGComposer: SVGComposer {
    
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
        setHeader(SVGComposerHeader())
        setupFileBeginning()
        setupGroups()
        setupFileEnding()
    }
    
    func writeToFile(inDirectory directoryURL: URL = FileManager.default.temporaryDirectory) -> Result<URL, Error> {
        return writeToFile(named: fileName, inDirectory: directoryURL)
    }
    
    // MARK: - Composing
    
    func setupFileBeginning() {
        addComponent(
            .beginFile(
                width: String(format: "%.f", UIScreen.main.bounds.width),
                height: String(format: "%d", 52 * paletteColors.count)
            ),
            appendingLineBreak: true
        )
    }
    
    func setupFileEnding() {
        addComponent(.endFile)
    }
    
    func setupGroups() {
        for colorIndex in 0..<paletteColors.count {
            addComponents(makeGroupForColor(atIndex: colorIndex))
        }
    }
    
    func makeGroupForColor(atIndex colorIndex: Int) -> [FileComponentProtocol] {
        guard colorIndex < paletteColors.count else { return [] }
        let color = paletteColors[colorIndex]
        guard let colorName = color.name else { return [] }
        
        var group: [FileComponentProtocol] = []
        
        group.append(contentsOf: beginColorGroup(id: colorName))
        group.append(contentsOf: rectForColor(atIndex: colorIndex))
        group.append(contentsOf: nameTextForColor(atIndex: colorIndex))
        group.append(contentsOf: hexTextForColor(atIndex: colorIndex))
        group.append(contentsOf: endColorGroup())
        
        return group
    }
    
    func beginColorGroup(id: String) -> [FileComponentProtocol] {
        return [.tab, .beginGroup(id: id), .lineBreak,]
    }
    
    func endColorGroup() -> [FileComponentProtocol] {
        return [.tab, .endGroup, .lineBreak,]
    }
    
    func rectForColor(atIndex colorIndex: Int) -> [FileComponentProtocol] {
        guard colorIndex < paletteColors.count else { return [] }
        let color = paletteColors[colorIndex]
        let height = 52
        let yString = String(format: "%d", colorIndex * height)
        let widthString = String(format: "%.f", UIScreen.main.bounds.width)
        let heightString = String(format: "%d", height)
        let colorHex = ColorFormatter(prefix: "#").stringFromInt(rgba: color.colorHex)
        return [.tab, .tab, .rect(y: yString, width: widthString, height: heightString, fill: colorHex), .lineBreak,]
    }
    
    func nameTextForColor(atIndex colorIndex: Int) -> [FileComponentProtocol] {
        guard colorIndex < paletteColors.count else { return [] }
        let color = paletteColors[colorIndex]
        guard let colorName = color.name else { return [] }
        let height = 52
        let yString = String(format: "%d", 41 + (colorIndex * height))
        let textFillHex = UIColor(rgba: Int(color.colorHex)).textColor()?.rgbaInt() ?? 0xFFFFFFFF
        let textFill = ColorFormatter(prefix: "#").stringFromInt(rgba: Int64(textFillHex))
        return [.tab, .tab, .text(x: "8", y: yString, fill: textFill, text: colorName), .lineBreak,]
    }
    
    func hexTextForColor(atIndex colorIndex: Int) -> [FileComponentProtocol] {
        guard colorIndex < paletteColors.count else { return [] }
        let color = paletteColors[colorIndex]
        let height = 52
        let yString = String(format: "%d", 41 + (colorIndex * height))
        let textFillHex = UIColor(rgba: Int(color.colorHex)).secondaryTextColor()?.rgbaInt() ?? 0xAAAAAAFF
        let textFill = ColorFormatter(prefix: "#").stringFromInt(rgba: Int64(textFillHex))
        let colorHex = ColorFormatter(prefix: "#").stringFromInt(rgba: color.colorHex)
        return [.tab, .tab, .text(x: "299", y: yString, fill: textFill, text: colorHex), .lineBreak,]
    }
}

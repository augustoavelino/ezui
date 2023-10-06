//
//  SVGComposer.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

class SVGComposer: FileComposerProtocol {
    
    // MARK: Associated types
    
    typealias FileHeaderProtocol = SVGComposerHeader
    typealias FileComponentProtocol = SVGComposerComponent
    
    // MARK: - Properties
    
    private var header: FileHeaderProtocol?
    private var components: [FileComponentProtocol] = []
    
    // MARK: - Composing
    
    func compose() -> String {
        var fileContents = ""
        if let header = header {
            fileContents.append(header.stringValue)
        }
        for component in components {
            fileContents.append(component.stringValue)
        }
        return fileContents
    }
    
    func writeToFile(named fileName: String, inDirectory directoryURL: URL = FileManager.default.temporaryDirectory) -> Result<URL, Error> {
        return writeToFile(named: fileName, withExtension: ".svg", inDirectory: directoryURL)
    }
    
    func setHeader(_ header: FileHeaderProtocol) {
        self.header = header
    }
    
    func setComponents(_ components: [FileComponentProtocol]) {
        self.components = components
    }
    
    func addComponent(_ component: FileComponentProtocol, appendingLineBreak: Bool = false) {
        components.append(component)
        if appendingLineBreak { components.append(.lineBreak) }
    }
    
    func addComponents(_ components: [FileComponentProtocol]) {
        self.components.append(contentsOf: components)
    }
}

// MARK: - FileComposerHeaderProtocol

struct SVGComposerHeader: FileComposerHeaderProtocol {
    var stringValue: String {
        var appVersion = "1.0.0"
        if let safeVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = safeVersion
        }
        return .appStringFormatted(.svgContent(.fileHeader), appVersion)
    }
}

// MARK: - FileComposerComponentProtocol

enum SVGComposerComponent: FileComposerComponentProtocol {
    
    // MARK: Cases
    
    case lineBreak
    case tab
    case emptySpace
    case rawText(text: String)
    case beginFile(width: String, height: String)
    case endFile
    case beginGroup(id: String)
    case endGroup
    case rect(y: String, width: String, height: String, fill: String)
    case text(x: String, y: String, fill: String, text: String)
    
    // MARK: - Values
    
    var stringValue: String {
        switch self {
        case .lineBreak: return "\n"
        case .tab: return "\t"
        case .emptySpace: return " "
        case .rawText(text: let text): return text
        case .beginFile(let width, let height):
            return .appStringFormatted(.svgContent(.beginFile), width, height)
        case .endFile:
            return .appString(.svgContent(.endFile))
        case .beginGroup(let id):
            return .appStringFormatted(.svgContent(.beginGroup), id)
        case .endGroup:
            return .appString(.svgContent(.endGroup))
        case .rect(let y, let width, let height, let fill):
            return .appStringFormatted(.svgContent(.rect), y, width, height, fill)
        case .text(let x, let y, let fill, let text):
            return .appStringFormatted(.svgContent(.text), x, y, fill, text)
        }
    }
}

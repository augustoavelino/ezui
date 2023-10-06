//
//  JSONComposer.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 26/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

class JSONComposer: FileComposerProtocol {
    
    // MARK: Associated types
    
    typealias FileHeaderProtocol = JSONComposerHeader
    typealias FileComponentProtocol = JSONComposerComponent
    
    // MARK: - Properties
    
    private var components: [FileComponentProtocol] = []
    
    // MARK: - Composing
    
    func compose() -> String {
        var fileContents = ""
        for component in components {
            fileContents.append(component.stringValue)
        }
        return fileContents
    }
    
    func writeToFile(named fileName: String, inDirectory directoryURL: URL = FileManager.default.temporaryDirectory) -> Result<URL, Error> {
        return writeToFile(named: fileName, withExtension: ".json", inDirectory: directoryURL)
    }
    
    func setHeader(_ header: FileHeaderProtocol) { return }
    
    func setComponents(_ components: [JSONComposerComponent]) {
        self.components = components
    }
    
    func addComponent(_ component: FileComponentProtocol, appendingLineBreak: Bool) {
        components.append(component)
        if appendingLineBreak { components.append(.lineBreak) }
    }
    
    func addComponents(_ components: [FileComponentProtocol]) {
        self.components.append(contentsOf: components)
    }
}

// MARK: - FileComposerHeaderProtocol

enum JSONComposerHeader: FileComposerHeaderProtocol {
    var stringValue: String { "" }
}

// MARK: - FileComposerComponentProtocol

enum JSONComposerComponent: FileComposerComponentProtocol {
    
    // MARK: Cases
    
    case tab
    case colon
    case comma
    case lineBreak
    case emptySpace
    case openArray
    case closeArray
    case openObject
    case closeObject
    case plain(text: String)
    case key(key: String)
    case keyInt(key: String, value: Int)
    case keyDouble(key: String, value: Double)
    case keyString(key: String, value: String)
    
    // MARK: - Values
    
    var stringValue: String {
        switch self {
        case .tab: return "\t"
        case .colon: return ":"
        case .comma: return ","
        case .lineBreak: return "\n"
        case .emptySpace: return " "
        case .openArray: return "["
        case .closeArray: return "]"
        case .openObject: return "{"
        case .closeObject: return "}"
        case .plain(let text): return text
        case .key(let key): return "\"\(key.camelCased())\""
        case .keyInt(let key, let value): return "\"\(key.camelCased())\": \(value)"
        case .keyDouble(let key, let value): return "\"\(key.camelCased())\": \(value)"
        case .keyString(let key, let value): return "\"\(key.camelCased())\": \"\(value)\""
        }
    }
}

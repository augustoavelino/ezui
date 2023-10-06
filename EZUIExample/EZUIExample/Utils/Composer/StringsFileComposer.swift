//
//  StringsFileComposer.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

class StringsFileComposer: FileComposerProtocol {
    
    // MARK: Associated types
    
    typealias FileHeaderProtocol = StringsFileComposerHeader
    typealias FileComponentProtocol = StringsFileComposerComponent
    
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
        return writeToFile(named: fileName, withExtension: ".strings", inDirectory: directoryURL)
    }
    
    func setHeader(_ header: FileHeaderProtocol) {
        self.header = header
    }
    
    func setComponents(_ components: [StringsFileComposerComponent]) {
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

struct StringsFileComposerHeader: FileComposerHeaderProtocol {
    
    // MARK: Properties
    
    private let fileName: String
    private let project: String
    private let author: String
    private let date: String
    private let year: String
    
    // MARK: - Life cycle
    
    init(fileName: String, project: String, author: String, date: String, year: String) {
        self.fileName = fileName
        self.project = project
        self.author = author
        self.date = date
        self.year = year
    }
    
    // MARK: - Value
    
    var stringValue: String {
        return .appStringFormatted(.stringsFileContent(.fileHeader), fileName, project, author, date, year, author)
    }
}

// MARK: - FileComposerComponentProtocol

enum StringsFileComposerComponent: FileComposerComponentProtocol {
    
    // MARK: Cases
    
    case tab
    case colon
    case comma
    case lineBreak
    case emptySpace
    case plain(text: String)
    case keyValue(key: String, value: String)
    
    // MARK: - Values
    
    var stringValue: String {
        switch self {
        case .tab: return "\t"
        case .colon: return ":"
        case .comma: return ","
        case .lineBreak: return "\n"
        case .emptySpace: return " "
        case .plain(let text): return text
        case .keyValue(let key, let value): return .appStringFormatted(.stringsFileContent(.keyValue), key.camelCased(), value)
        }
    }
}

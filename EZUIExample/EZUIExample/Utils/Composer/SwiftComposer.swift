//
//  SwiftComposer.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 23/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

class SwiftComposer: FileComposerProtocol {
    
    // MARK: Associated types
    
    typealias FileHeaderProtocol = SwiftComposerHeader
    typealias FileComponentProtocol = SwiftComposerComponent
    
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
        return writeToFile(named: fileName, withExtension: ".swift", inDirectory: directoryURL)
    }
    
    func setHeader(_ header: FileHeaderProtocol) {
        self.header = header
    }
    
    func setComponents(_ components: [SwiftComposerComponent]) {
        self.components = components
    }
    
    func addComponent(_ component: FileComponentProtocol, appendingLineBreak: Bool = false) {
        components.append(component)
        if appendingLineBreak { components.append(.lineBreak) }
    }
    
    func addComponents(_ components: [SwiftComposerComponent]) {
        for component in components {
            addComponent(component)
        }
    }
}

// MARK: - FileComposerHeaderProtocol

struct SwiftComposerHeader: FileComposerHeaderProtocol {
    
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
        return .appStringFormatted(.swiftComments(.fileHeader), fileName, project, author, date, year, author)
    }
}

// MARK: - FileComposerComponentProtocol

enum SwiftComposerComponent: FileComposerComponentProtocol {
    
    // MARK: Cases
    
    case colon
    case emptySpace
    case tab
    case assignValue
    case rawText(text: String)
    case importModule(moduleName: String)
    case classDeclaration(className: String)
    case enumDeclaration(enumName: String)
    case enumRawValueDeclaration(enumName: String, rawType: String)
    case structDeclaration(structName: String)
    case protocolDeclaration(protocolName: String)
    case caseDeclaration(caseName: String)
    case caseRawValueDeclaration(caseName: String, rawValue: String)
    case beginDeclaration
    case endDeclaration
    case lineBreak
    case varDeclaration(variableName: String)
    case letDeclaration(constantName: String)
    case staticVarDeclaration(variableName: String)
    case staticLetDeclaration(constantName: String)
    case weakVarDeclaration(variableName: String)
    case uiColorRGBInit(hexString: String)
    case uiColorRGBAInit(hexString: String)
    
    // MARK: - Values
    
    var stringValue: String {
        switch self {
        case .colon:
            return .appString(.swiftCode(.colon))
        case .emptySpace:
            return .appString(.swiftCode(.emptySpace))
        case .tab:
            return .appString(.swiftCode(.tab))
        case .assignValue:
            return .appString(.swiftCode(.assignValue))
        case .rawText(let text):
            return text
        case .importModule(let moduleName):
            return .appStringFormatted(.swiftCode(.importModule), moduleName)
        case .classDeclaration(let className):
            return .appStringFormatted(.swiftCode(.classDeclaration), className.upperCamelCased())
        case .enumDeclaration(let enumName):
            return .appStringFormatted(.swiftCode(.enumDeclaration), enumName.upperCamelCased())
        case .enumRawValueDeclaration(let enumName, let rawType):
            return .appStringFormatted(.swiftCode(.enumRawValueDeclaration), enumName.upperCamelCased(), rawType)
        case .structDeclaration(let structName):
            return .appStringFormatted(.swiftCode(.structDeclaration), structName.upperCamelCased())
        case .protocolDeclaration(let protocolName):
            return .appStringFormatted(.swiftCode(.protocolDeclaration), protocolName.upperCamelCased())
        case .caseDeclaration(let caseName):
            return .appStringFormatted(.swiftCode(.caseDeclaration), caseName.camelCased())
        case .caseRawValueDeclaration(let caseName, let rawValue):
            return .appStringFormatted(.swiftCode(.caseRawValueDeclaration), caseName.camelCased(), rawValue)
        case .beginDeclaration:
            return .appString(.swiftCode(.beginDeclaration))
        case .endDeclaration:
            return .appString(.swiftCode(.endDeclaration))
        case .lineBreak:
            return "\n"
        case .varDeclaration(let variableName):
            return .appStringFormatted(.swiftCode(.varDeclaration), variableName.camelCased())
        case .letDeclaration(let constantName):
            return .appStringFormatted(.swiftCode(.letDeclaration), constantName.camelCased())
        case .staticVarDeclaration(let variableName):
            return .appStringFormatted(.swiftCode(.staticVarDeclaration), variableName.camelCased())
        case .staticLetDeclaration(let constantName):
            return .appStringFormatted(.swiftCode(.staticLetDeclaration), constantName.camelCased())
        case .weakVarDeclaration(let variableName):
            return .appStringFormatted(.swiftCode(.weakVarDeclaration), variableName.camelCased())
        case .uiColorRGBInit(let hexString):
            return .appStringFormatted(.swiftCode(.uiColorRGBInit), hexString)
        case .uiColorRGBAInit(let hexString):
            return .appStringFormatted(.swiftCode(.uiColorRGBAInit), hexString)
        }
    }
}

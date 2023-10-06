//
//  String+Localization.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 16/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

extension String {
    // TODO: Cleanup code - remove testing code
    private static let testingPTVersion = false // DEBUG control
    
    static func appString(_ stringInfo: AppString) -> String {
        return localizedStringInfo(stringInfo)
    }
    
    static func appStringFormatted(_ stringInfo: AppString, _ arguments: CVarArg...) -> String {
        return localizedStringFormatted(stringInfo.key, tableName: stringInfo.tableName, arguments)
    }
    
    static func localizedStringInfo(_ stringInfo: LocalizedStringInfo) -> String {
        return localizedString(stringInfo.key, tableName: stringInfo.tableName)
    }
    
    static func localizedStringInfoFormatted(_ stringInfo: LocalizedStringInfo, _ arguments: CVarArg...) -> String {
        return localizedStringFormatted(stringInfo.key, tableName: stringInfo.tableName, arguments)
    }
    
    static func localizedString(_ key: String, tableName: String) -> String {
        if testingPTVersion,
           let path = Bundle.main.path(forResource: "pt-BR", ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return NSLocalizedString(key, tableName: tableName, bundle: bundle, comment: "")
        }
        return NSLocalizedString(key, tableName: tableName, comment: "")
    }
    
    static func localizedStringFormatted(_ key: String, tableName: String, _ arguments: CVarArg...) -> String {
        let formatString = localizedString(key, tableName: tableName)
        return String(format: formatString, arguments)
    }
}

// MARK: - Localized string info

protocol LocalizedStringInfo {
    var tableName: String { get }
    var key: String { get }
}

protocol LocalizedStringKeyType {
    var rawValue: String { get }
    var key: String { get }
}

extension LocalizedStringKeyType {
    var key: String { rawValue }
}

// MARK: - App string type

enum AppString: LocalizedStringInfo {
    case documentationMenu(DocumentationMenu)
    case iconography(Iconography)
    case menu(Menu)
    case settings(Settings)
    case svgContent(SVGContent)
    case stringsFileContent(StringsFileContent)
    case swiftComments(SwiftComments)
    case swiftCode(SwiftCode)
    
    var tableName: String {
        switch self {
        case .documentationMenu(_): return "DocumentationMenu"
        case .iconography(_): return "Iconography"
        case .menu(_): return "Menu"
        case .settings(_): return "Settings"
        case .svgContent(_): return "SVGContent"
        case .stringsFileContent(_): return "StringsFileContent"
        case .swiftComments(_): return "SwiftComments"
        case .swiftCode(_): return "SwiftCode"
        }
    }
    
    var key: String {
        switch self {
        case .documentationMenu(let docString): return docString.key
        case .iconography(let iconography): return iconography.key
        case .menu(let menu): return menu.key
        case .settings(let settings): return settings.key
        case .svgContent(let svgContent): return svgContent.key
        case .stringsFileContent(let stringsFileContent): return stringsFileContent.key
        case .swiftComments(let swiftComment): return swiftComment.key
        case .swiftCode(let swiftCode): return swiftCode.key
        }
    }
    
    // MARK: Tables
    
    enum DocumentationMenu: String, LocalizedStringKeyType {
        case title
    }
    
    enum Iconography: String, LocalizedStringKeyType {
        case title
        case segmentAll
        case segmentFavorites
    }
    
    enum Menu: String, LocalizedStringKeyType {
        case title
        case resourcesSectionTitle
        case stylesSectionTitle
        case componentsSectionTitle
        case compositionSectionTitle
        case stringsTitle
        case imagesTitle
        case colorPaletteTitle
        case typographyTitle
        case iconographyTitle
        case buttonTitle
        case viewComposerTitle
        case viewLayoutTitle
    }
    
    enum Settings: String, LocalizedStringKeyType {
        case title
        case author
        case version// (module: String, version: String)
    }
    
    enum StringsFileContent: String, LocalizedStringKeyType {
        case fileHeader// (fileName: String, project: String, author: String, date: String, year: String)
        case keyValue// (key: String, value: String)
    }
    
    enum SVGContent: String, LocalizedStringKeyType {
        case fileHeader// (generatorVersion: String)
        case beginFile// (width: String, height: String)
        case endFile
        case beginGroup// (id: String)
        case endGroup
        case rect// (y: String, width: String, height: String, fill: String)
        case text// (x: String, y: String, fill: String, text: String)
    }
    
    enum SwiftComments: String, LocalizedStringKeyType {
        case fileHeader// (fileName: String, project: String, author: String, date: String, year: String)
    }
    
    enum SwiftCode: String, LocalizedStringKeyType {
        case colon
        case emptySpace
        case tab
        case assignValue
        case importModule// (moduleName: String)
        case classDeclaration// (class: String)
        case enumDeclaration// (enum: String)
        case enumRawValueDeclaration// (enum: String, rawType: String)
        case structDeclaration// (struct: String)
        case protocolDeclaration// (protocol: String)
        case extensionDeclaration// (extension: String)
        case caseDeclaration// (case: String)
        case caseRawValueDeclaration// (case: String, rawValue: String)
        case beginDeclaration
        case endDeclaration
        case varDeclaration// (variable: String)
        case letDeclaration// (constant: String)
        case staticVarDeclaration// (variable: String)
        case staticLetDeclaration// (constant: String)
        case weakVarDeclaration// (variable: String)
        case uiColorRGBInit// (hex: String)
        case uiColorRGBAInit// (hex: String)
    }
}

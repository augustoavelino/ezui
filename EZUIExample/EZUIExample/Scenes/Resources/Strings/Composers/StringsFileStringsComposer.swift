//
//  StringsFileStringsComposer.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

class StringsFileStringsComposer: StringsFileComposer {
    
    // MARK: Properties
    
    let stringsFile: StringsFile
    let strings: [StringsFileString]
    
    lazy var fileName: String = {
        guard let stringsFileName = stringsFile.name else { return "StringsFile" }
        return stringsFileName
    }()
    
    // MARK: - Life cycle
    
    init(stringsFile: StringsFile, strings: [StringsFileString]) {
        self.stringsFile = stringsFile
        self.strings = strings
        super.init()
        setupContent()
    }
    
    func setupContent() {
        setHeader(makeHeader())
        addComponents(makeAllStrings())
    }
    
    func writeToFile(inDirectory directoryURL: URL = FileManager.default.temporaryDirectory) -> Result<URL, Error> {
        return writeToFile(named: fileName.upperCamelCased(), inDirectory: directoryURL)
    }
    
    // MARK: - Composing
    
    func makeHeader() -> StringsFileComposerHeader {
        let date = Date()
        return StringsFileComposerHeader(
            fileName: fileName.upperCamelCased(),
            project: "EZUI",
            author: "Augusto Avelino",
            date: AppDateFormatter.shared.string(from: date, format: "dd/MM/yy"),
            year: AppDateFormatter.shared.string(from: date, format: "yyyy")
        )
    }
    
    func makeAllStrings() -> [StringsFileComposerComponent] {
        var components: [StringsFileComposerComponent] = []
        for string in strings {
            components.append(contentsOf: makeConstant(string: string))
        }
        return components
    }
    
    func makeConstant(string: StringsFileString) -> [StringsFileComposerComponent] {
        guard let stringKey = string.key,
              let stringValue = string.value else { return [] }
        return [.keyValue(key: stringKey, value: stringValue),]
    }
}

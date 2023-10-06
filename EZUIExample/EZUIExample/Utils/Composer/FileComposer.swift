//
//  FileComposer.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 23/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

protocol FileComposerHeaderProtocol {
    var stringValue: String { get }
}

protocol FileComposerComponentProtocol {
    var stringValue: String { get }
}

protocol FileComposerProtocol {
    associatedtype FileComponentProtocol: FileComposerComponentProtocol
    associatedtype FileHeaderProtocol: FileComposerHeaderProtocol
    
    func compose() -> String
    func writeToFile(
        named fileName: String,
        withExtension fileExtension: String,
        inDirectory directoryURL: URL
    ) -> Result<URL, Error>
    
    func setHeader(_ header: FileHeaderProtocol)
    func setComponents(_ components: [FileComponentProtocol])
    func addComponent(_ component: FileComponentProtocol, appendingLineBreak: Bool)
    func addComponents(_ components: [FileComponentProtocol])
}

extension FileComposerProtocol {
    func writeToFile(
        named fileName: String,
        withExtension fileExtension: String,
        inDirectory directoryURL: URL = FileManager.default.temporaryDirectory
    ) -> Result<URL, Error> {
        let fileURL = directoryURL.appendingPathComponent(fileName + fileExtension)
        do {
            let value = compose()
            try value.write(to: fileURL, atomically: false, encoding: .utf8)
            return .success(fileURL)
        } catch {
            return .failure(error)
        }
    }
}

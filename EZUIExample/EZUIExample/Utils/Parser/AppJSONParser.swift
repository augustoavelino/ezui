//
//  AppJSONParser.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 26/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

protocol AppJSONCodable {
    
}

protocol AppJSONParserProtocol {
    func stringify(_ jsonDictionary: [String: Any]) throws -> String
    func parse(_ jsonString: String) throws -> [String: Any]
}

class AppJSONParser: AppJSONParserProtocol {
    
    // MARK: Singleton
    
    static let shared = AppJSONParser()
    
    // MARK: - Life cycle
    
    fileprivate init() {}
    
    // MARK: - AppJSONParserProtocol
    
    func stringify(_ jsonDictionary: [String: Any]) throws -> String {
//        let decoder = JSONDecoder()
        return ""
    }
    
    func parse(_ jsonString: String) throws -> [String: Any] {
        return [:]
    }
}

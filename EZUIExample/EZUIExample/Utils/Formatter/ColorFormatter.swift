//
//  ColorFormatter.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 24/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import EZUI

class ColorFormatter {
    
    // MARK: Properties
    
    var prefix: String
    
    // MARK: - Life cycle
    
    init(prefix: String = "0x") {
        self.prefix = prefix
    }
    
    // MARK: - Formatting
    
    func intFromString(rgb string: String) -> Int64? {
        let cleanString = removePrefix(from: string)
        return Int64(cleanString, radix: 16)
    }
    
    func intFromString(rgba string: String) -> Int64? {
        return intFromString(rgb: string)
    }
    
    private func removePrefix(from string: String) -> String {
        return string.lowercased()
            .replacingOccurrences(of: "0x", with: "")
            .replacingOccurrences(of: "#", with: "")
    }
    
    func stringFromInt(rgb: Int64, uppercase: Bool = true) -> String {
        return prefix + String(rgb, radix: 16, uppercase: uppercase).leftPadding(toLength: 6, withPad: "0")
    }
    
    func stringFromInt(rgba: Int64, uppercase: Bool = true) -> String {
        return prefix + String(rgba, radix: 16, uppercase: uppercase).leftPadding(toLength: 8, withPad: "0")
    }
}

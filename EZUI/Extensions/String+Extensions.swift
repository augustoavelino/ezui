//
//  String+Extensions.swift
//  EZUI
//
//  Created by Augusto Avelino on 23/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

public extension String {
    func leftPadding(toLength: Int, withPad character: Character) -> String {
        if count < toLength + 1 {
            return String(repeatElement(character, count: toLength - count)) + self
        } else {
            return String(self[index(endIndex, offsetBy: -toLength)..<endIndex])
        }
    }
}

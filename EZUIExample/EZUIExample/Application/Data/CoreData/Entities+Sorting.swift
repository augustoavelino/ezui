//
//  Entities+Sorting.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 16/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import CoreData

// MARK: Color palette

extension Palette: Comparable {
    public static func < (lhs: Palette, rhs: Palette) -> Bool {
        guard let lName = lhs.name, let rName = rhs.name, lName != rName else {
            guard let lDateUpdated = lhs.dateUpdated, let rDateUpdated = rhs.dateUpdated, lDateUpdated != rDateUpdated else {
                return false
            }
            return lDateUpdated < rDateUpdated
        }
        return lName < rName
    }
}

extension PaletteColor: Comparable {
    public static func < (lhs: PaletteColor, rhs: PaletteColor) -> Bool {
        guard let lName = lhs.name, let rName = rhs.name, lName != rName else { return false }
        return lName < rName
    }
}

// MARK: - Strings

extension StringsFile: Comparable {
    public static func < (lhs: StringsFile, rhs: StringsFile) -> Bool {
        guard let lName = lhs.name, let rName = rhs.name, lName != rName else {
            guard let lDateUpdated = lhs.dateUpdated, let rDateUpdated = rhs.dateUpdated, lDateUpdated != rDateUpdated else {
                return false
            }
            return lDateUpdated < rDateUpdated
        }
        return lName < rName
    }
}

extension StringsFileString: Comparable {
    public static func < (lhs: StringsFileString, rhs: StringsFileString) -> Bool {
        guard let lKey = lhs.key, let rKey = rhs.key, lKey != rKey else { return false }
        return lKey < rKey
    }
}

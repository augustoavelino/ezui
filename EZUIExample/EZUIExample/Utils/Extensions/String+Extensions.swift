//
//  String+Extensions.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 27/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

public extension String {
    func camelCased() -> String {
        let stringComponents = components(separatedBy: " ")
        if stringComponents.count > 1 {
            guard let firstComponent = stringComponents.first?.camelCased() else { return self }
            let remainingComponents = stringComponents.dropFirst().compactMap { $0.upperCamelCased() }
            let finalComponent = remainingComponents.reduce("", +)
            return firstComponent.appending(finalComponent)
        } else {
            guard let firstLetter = self.first?.lowercased() else { return self }
            let remainingContent = self.dropFirst()
            return String(firstLetter) + remainingContent
        }
    }
    
    func upperCamelCased() -> String {
        let stringComponents = components(separatedBy: " ")
        if stringComponents.count > 1 {
            let components = stringComponents.compactMap { $0.upperCamelCased() }
            let finalComponent = components.reduce("", +)
            return finalComponent
        } else {
            guard let firstLetter = self.first?.uppercased() else { return self }
            let remainingContent = self.dropFirst()
            return String(firstLetter) + remainingContent
        }
    }
}

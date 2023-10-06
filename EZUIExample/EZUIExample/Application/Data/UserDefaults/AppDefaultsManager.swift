//
//  AppDefaultsManager.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 26/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

enum AppDefaultsKey: String, CaseIterable, AppDefaultsKeyProtocol {
    case appTintColor = "application-tint-color"
    case authorName = "project-author-name"
    case iconographyStyleMode = "iconography-style-mode"
    case iconographyColorMode = "iconography-color-mode"
    case iconographyFavorites = "iconography-favorites"
}


class AppDefaultsManager: AppDefaultsManagerProtocol {
    typealias DefaultsKey = AppDefaultsKey
    
    static let shared = AppDefaultsManager()
    
    fileprivate init() {}
}

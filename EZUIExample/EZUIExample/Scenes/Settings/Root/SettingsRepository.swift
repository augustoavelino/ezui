//
//  SettingsRepository.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 17/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

protocol SettingsRepoProtocol {
    func getAuthorName() -> Result<String?, Error>
    func setAuthorName(_ name: String?) -> Result<Void, Error>
    
    func getSelectedTintIndex() -> Result<Int?, Error>
    func getAvailableTintColors() -> Result<[SettingsTintManagerColor], Error>
    func setApplicationTintColor(atIndex colorIndex: Int) -> Result<Bool, Error>
}

class SettingsRepository: SettingsRepoProtocol {
    var authorName: String?
    let tintColors = SettingsTintManagerColor.allCases
    
    func getAuthorName() -> Result<String?, Error> {
        if let authorName = authorName { return .success(authorName) }
        guard let savedName = AppDefaultsManager.shared.string(forKey: .authorName),
              !savedName.isEmpty else {
            return .success(nil)
        }
        self.authorName = savedName
        return .success(savedName)
    }
    
    func setAuthorName(_ name: String?) -> Result<Void, Error> {
        var newName: String?
        if let name = name, !name.isEmpty { newName = name }
        authorName = newName
        AppDefaultsManager.shared.set(newName, forKey: .authorName)
        return .success(())
    }
    
    func getSelectedTintIndex() -> Result<Int?, Error> {
        do {
            guard let selectedTint = try SettingsTintManager.shared.getTint().get() else { return .success(nil) }
            return .success(tintColors.firstIndex(of: selectedTint))
        } catch {
            return .failure(error)
        }
    }
    
    func getAvailableTintColors() -> Result<[SettingsTintManagerColor], Error> {
        return .success(tintColors)
    }
    
    func setApplicationTintColor(atIndex colorIndex: Int) -> Result<Bool, Error> {
        var didSelect = true
        if let selectedIndex = try? getSelectedTintIndex().get(),
           colorIndex == selectedIndex {
            didSelect = false
        } else {
            didSelect = colorIndex < tintColors.count
        }
        do {
            if didSelect {
                try SettingsTintManager.shared.setTint(tintColors[colorIndex]).get()
            } else {
                try SettingsTintManager.shared.setTint(nil).get()
            }
        } catch {
            return .failure(error)
        }
        return .success(didSelect)
    }
}

// MARK: - AppErrorSource

extension SettingsRepository: AppErrorSource {
    enum AppErrorType: Int, AppErrorProtocol {
        case unexpected = 1001
        
        var domain: String { "SettingsBusinessModel" }
        var code: Int { rawValue }
        var message: String {
            switch self {
            case .unexpected: return "An unexpected error has occurred"
            }
        }
    }
}

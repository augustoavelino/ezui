//
//  SettingsTintManager.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 20/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import UIKit

enum SettingsTintManagerColor: String, CaseIterable {
    case systemRed
    case systemGreen
    case systemBlue
    case systemYellow
    case systemOrange
    case systemPurple
    case systemIndigo
    
    var identifier: String { rawValue }
    var text: String {
        switch self {
        case .systemRed: return "System Red"
        case .systemGreen: return "System Green"
        case .systemBlue: return "System Blue"
        case .systemYellow: return "System Yellow"
        case .systemOrange: return "System Orange"
        case .systemPurple: return "System Purple"
        case .systemIndigo: return "System Indigo"
        }
    }
    var color: UIColor {
        switch self {
        case .systemRed: return .systemRed
        case .systemGreen: return .systemGreen
        case .systemBlue: return .systemBlue
        case .systemYellow: return .systemYellow
        case .systemOrange: return .systemOrange
        case .systemPurple: return .systemPurple
        case .systemIndigo: return .systemIndigo
        }
    }
    
}

protocol SettingsTintManagerProtocol {
    func getTint() -> Result<SettingsTintManagerColor?, Error>
    func getTintColor() -> Result<UIColor?, Error>
    func setTint(_ tint: SettingsTintManagerColor?) -> Result<Void, Error>
    func resetTint()
}

class SettingsTintManager: SettingsTintManagerProtocol {
    
    // MARK: Singleton
    
    static let shared = SettingsTintManager()
    
    // MARK: - Life cycle
    
    init() {}
    
    func getTint() -> Result<SettingsTintManagerColor?, Error> {
        guard let tintIdentifier = AppDefaultsManager.shared.string(forKey: .appTintColor) else { return .success(nil) }
        return .success(SettingsTintManagerColor(rawValue: tintIdentifier))
    }
    
    func getTintColor() -> Result<UIColor?, Error> {
        do {
            let tint = try getTint().get()
            return .success(tint?.color)
        } catch {
            return .failure(error)
        }
    }
    
    func setTint(_ tint: SettingsTintManagerColor?) -> Result<Void, Error> {
        applyTint(tint)
        guard let tint = tint else {
            AppDefaultsManager.shared.removeValue(forKey: .appTintColor)
            return .success(())
        }
        AppDefaultsManager.shared.set(tint.identifier, forKey: .appTintColor)
        return .success(())
    }
    
    func resetTint() {
        do {
            try setTint(nil).get()
        } catch {
            print(error)
        }
    }
    
    func applyTint(_ tint: SettingsTintManagerColor?) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.window?.tintColor = tint?.color
    }
}

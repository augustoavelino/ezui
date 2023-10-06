//
//  AppDefaultsManagerProtocol.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 26/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

protocol AppDefaultsKeyProtocol {
    var rawValue: String { get }
}

protocol AppDefaultsManagerProtocol {
    associatedtype DefaultsKey: AppDefaultsKeyProtocol
    
    func hasValue(forKey key: DefaultsKey) -> Bool
    func value(forKey key: DefaultsKey) -> Any?
    func set(_ value: Any?, forKey key: DefaultsKey)
    func migrateValue(from fromKey: DefaultsKey, to toKey: DefaultsKey, handler: @escaping (Any) -> Any)
    func removeValue(forKey key: DefaultsKey)
    
    func int(forKey key: DefaultsKey) -> Int?
    func double(forKey key: DefaultsKey) -> Double?
    func string(forKey key: DefaultsKey) -> String?
}

extension AppDefaultsManagerProtocol {
    func hasValue(forKey key: DefaultsKey) -> Bool {
        return UserDefaults.standard.object(forKey: key.rawValue) != nil
    }
    
    func value(forKey key: DefaultsKey) -> Any? {
        return UserDefaults.standard.object(forKey: key.rawValue)
    }
    
    func set(_ value: Any?, forKey key: DefaultsKey) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
    
    func migrateValue(from fromKey: DefaultsKey, to toKey: DefaultsKey, handler: @escaping (Any) -> Any = { $0 }) {
        guard let movedValue = value(forKey: fromKey) else { return }
        let finalValue = handler(movedValue)
        set(finalValue, forKey: toKey)
        removeValue(forKey: fromKey)
    }
    
    func removeValue(forKey key: DefaultsKey) {
        UserDefaults.standard.removeObject(forKey: key.rawValue)
    }
    
    func int(forKey key: DefaultsKey) -> Int? {
        return value(forKey: key) as? Int
    }
    func double(forKey key: DefaultsKey) -> Double? {
        return value(forKey: key) as? Double
    }
    func string(forKey key: DefaultsKey) -> String? {
        return value(forKey: key) as? String
    }
}

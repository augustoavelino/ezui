//
//  AppCacheManager.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 13/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import Foundation

class AppCacheContainer<DataType: Any> {
    var data: DataType? = nil
    
    init(data: DataType? = nil) {
        self.data = data
    }
}

protocol AppCacheManagerProtocol {
    func clearCaches()
    func fetchData<DataType: Any>(forKey key: NSString) -> Result<DataType, Error>
    func cacheData<DataType: Any>(_ data: DataType, forKey key: NSString)
}

class AppCacheManager: AppCacheManagerProtocol {
    
    // MARK: Caches
    
    private let cache = NSCache<NSString, AppCacheContainer<Any>>()
    
    // MARK: Singleton
    
    static let shared = AppCacheManager()
    
    // MARK: - Life cycle
    
    fileprivate init() {}
    
    // MARK: - Cache operations
    
    func clearCaches() {
        cache.removeAllObjects()
    }
    
    func fetchData<DataType: Any>(forKey key: NSString) -> Result<DataType, Error> {
        guard let container = cache.object(forKey: key) else {
            return .failure(error(.containerNotFound("\(DataType.self)")))
        }
        guard let data = container.data as? DataType else {
            return .failure(error(.containerEmpty("\(DataType.self)")))
        }
        return .success(data)
    }
    
    func cacheData<DataType: Any>(_ data: DataType, forKey key: NSString) {
        let container: AppCacheContainer<Any> = AppCacheContainer(data: data)
        cache.setObject(container, forKey: key)
    }
}

// MARK: - Error handling

extension AppCacheManager: AppErrorSource {
    enum AppErrorType: AppErrorProtocol {
        case containerEmpty(String)
        case containerNotFound(String)
        
        var domain: String {
            switch self {
            case .containerEmpty(let container): return container + "Cache"
            case .containerNotFound(let container): return container + "Cache"
            }
        }
        
        var code: Int {
            switch self {
            case .containerEmpty(_): return 1001
            case .containerNotFound(_): return 1002
            }
        }
        
        var message: String {
            switch self {
            case .containerEmpty(let container): return container + " container is empty"
            case .containerNotFound(let container): return container + " container not found"
            }
        }
    }
}

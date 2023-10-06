//
//  AppCoreDataManager.swift
//  EZUIExample
//
//  Created by Augusto Avelino on 15/06/23.
//  Copyright © 2023 Augusto Avelino. All rights reserved.
//

import CoreData

protocol AppCoreDataManagerProtocol {
    func create<DataType: NSManagedObject>(_ dataType: DataType.Type, handler: @escaping (DataType) -> Void) -> Result<DataType, Error>
    func fetch<DataType: NSManagedObject>(_ dataType: DataType.Type, predicate: NSPredicate?) -> Result<[DataType], Error>
    func update<DataType: NSManagedObject>(_ object: DataType, handler: @escaping (DataType) -> Void) -> Result<Void, Error>
    func delete<DataType: NSManagedObject>(_ object: DataType) -> Result<Void, Error>
    func saveIfChanged()
}

class AppCoreDataManager: AppCoreDataManagerProtocol {
    
    // MARK: Singleton
    
    static let shared = AppCoreDataManager()
    
    // MARK: Container
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { [weak self] store, error in
            guard let self = self else { return }
            if let error = error as? NSError {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            print(store)
        }
        return container
    }()
    
    // MARK: - Life cycle
    
    fileprivate init() {}
    
    // MARK: - Operations
    
    func fetch<DataType: NSManagedObject>(_ dataType: DataType.Type, predicate: NSPredicate? = nil) -> Result<[DataType], Error> {
        let context = container.viewContext
        let fetchRequest = DataType.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            guard let data = try context.fetch(fetchRequest) as? [DataType] else {
                return .failure(error(.fetch("\(DataType.self)", predicate?.description)))
            }
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    func create<DataType: NSManagedObject>(_ dataType: DataType.Type, handler: @escaping (DataType) -> Void) -> Result<DataType, Error> {
        let context = container.viewContext
        let data = DataType(context: context)
        handler(data)
        do {
            try saveContext(context)
            return .success(data)
        } catch {
            return .failure(error)
        }
    }
    
    func update<DataType: NSManagedObject>(_ object: DataType, handler: @escaping (DataType) -> Void) -> Result<Void, Error> {
        let context = container.viewContext
        handler(object)
        do {
            try saveContext(context)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func delete<DataType: NSManagedObject>(_ object: DataType) -> Result<Void, Error> {
        let context = container.viewContext
        context.delete(object)
        do {
            try saveContext(context)
            return .success(())
        } catch {
            return .failure(error)
        }
    }
    
    func saveIfChanged() {
        let context = container.viewContext
        guard context.hasChanges else { return }
        do {
            try saveContext(context)
        } catch {
            print("🛑 CoreDataError: \(error)")
        }
    }
    
    private func saveContext(_ context: NSManagedObjectContext) throws {
        try context.save()
        print("Context saved successfully")
    }
}

// MARK: - Error handling

extension AppCoreDataManager: AppErrorSource {
    enum AppErrorType: AppErrorProtocol {
        case fetch(String, String?)
        case delete(String)
        
        var domain: String { "AppCoreDataManager" }
        
        var code: Int {
            switch self {
            case .fetch(_, _): return 1001
            case .delete(_): return 1002
            }
        }
        
        var message: String {
            switch self {
            case .fetch(let container, let predicate): return container + " CoreData fetch failed with predicate: \(predicate ?? "None")"
            case .delete(let container): return container + "Core data failed to delete object"
            }
        }
    }
}

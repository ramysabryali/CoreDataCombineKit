//
//  CoreDataManager.swift
//  CoreDataCombineKit
//
//  Created by Ramy Sabry on 03/05/2022.
//

import CoreData

public final class CoreDataManager {
    private var coreDataStorageContext: CoreDataStorageContextContract?
    
    public static let shared = CoreDataManager()
    
    private init() {}
}

public extension CoreDataManager {
    static func setup(
        coreDataStorageContext: CoreDataStorageContextContract?
    ) {
        shared.coreDataStorageContext = coreDataStorageContext
    }
    
    func storageContext() throws -> CoreDataStorageContextContract {
        guard let coreDataStorageContext = coreDataStorageContext else {
//            fatalError("Storage context is nil, Call setup method to init core data context")
            throw CoreDataManagerError.storageContextIsNil
        }
        
        return coreDataStorageContext
    }
}

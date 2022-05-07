//
//  CoreDataManager.swift
//  CoreDataCombineKit
//
//  Created by Ramy Sabry on 03/05/2022.
//

import CoreData

/// Singleton to get a single coreDataStorageContext instanse
///
public final class CoreDataManager {
    private var coreDataStorageContext: CoreDataStorageContextContract?
    
    public static let shared = CoreDataManager()
    
    private init() {}
}

public extension CoreDataManager {
    /**
    This method sets the coreDataStorageContext
    - parameter coreDataStorageContext: CoreDataStorageContextContract.
    - Example
    ```
     let coreDataContext: CoreDataStorageContext = .init(
                 fileName: "UserManagement",
                 bundle: .main,
                 storeType: .sqLiteStoreType
             )
             
    CoreDataManager.setup(coreDataStorageContext: coreDataContext)
    ```
    */
    static func setup(
        coreDataStorageContext: CoreDataStorageContextContract?
    ) {
        shared.coreDataStorageContext = coreDataStorageContext
    }
    
    
    /**
    This method returns the coreDataStorageContext if is initiialized
    - returns: throws -> CoreDataStorageContextContract
    - warning: throws exception if the coreDataStorageContext is not initialized by calling the setup method
    ```
    */
    func storageContext() throws -> CoreDataStorageContextContract {
        guard let coreDataStorageContext = coreDataStorageContext else {
            throw CoreDataManagerError.storageContextIsNil
        }
        
        return coreDataStorageContext
    }
}

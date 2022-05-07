//
//  CoreDataStorageContext.swift
//  CoreDataCombineKit
//
//  Created by Ramy Sabry on 03/05/2022.
//

import CoreData

/// This class is container for the Core data NSManagedObjectModel, NSPersistentContainer ansNSManagedObjectContext instanses
///
public final class CoreDataStorageContext {
    private let fileName: String
    private let bundle: Bundle
    private let storeType: CoreDataStoreType
    
    private lazy var managedObjectModel: NSManagedObjectModel = initManagedObjectModel()
    private lazy var persistentContainer: NSPersistentContainer = initPersistentContainer()
    
    private lazy var forgroundContext: NSManagedObjectContext = initForgroundContext()
    private lazy var backgroundContext: NSManagedObjectContext = initBackgroundContext()
    
    
    /// This method sets the coreDataStorageContext
    /// - Parameters:
    ///   - fileName: String -> the xcdatamodeld file name
    ///   - bundle: Bundle -> the bundle for the xcdatamodeld file
    ///   - storeType: CoreDataStoreType -> persistentStore type (inMemory or sqLite)
     /**
    - Example
    ```
     let coreDataContext: CoreDataStorageContext = .init(
                 fileName: "UserManagement",
                 bundle: .main,
                 storeType: .sqLiteStoreType
             )
    ```
    */
    public init(
        fileName: String,
        bundle: Bundle = .main,
        storeType: CoreDataStoreType = .sqLiteStoreType
    ) {
        self.fileName = fileName
        self.bundle = bundle
        self.storeType = storeType
    }
}

// MARK: - CoreDataStorageContextContract

extension CoreDataStorageContext: CoreDataStorageContextContract {
    public func getForgroundContext() -> NSManagedObjectContext {
        return forgroundContext
    }
    
    public func getBackgroundContext() -> NSManagedObjectContext {
        return backgroundContext
    }
}

// MARK: - Private Helpers

private extension CoreDataStorageContext {
    func initManagedObjectModel() -> NSManagedObjectModel {
        guard let modelURL = FileManager.shared.getFile(
            fileName,
            withExtension: .careData,
            from: bundle
        ) else {
            fatalError("\(fileName) not found in bundle: \(bundle)")
        }
        
        guard let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Can't get NSManagedObjectModel from \(modelURL.absoluteString)")
        }
        
        return managedObjectModel
    }
    
    func initPersistentContainer() -> NSPersistentContainer {
        let persistentContainer = NSPersistentContainer(
            name: fileName,
            managedObjectModel: self.managedObjectModel
        )
        let description = persistentContainer.persistentStoreDescriptions.first
        description?.type = storeType.value
        
        persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                fatalError("was unable to load store \(error)")
            }
        }
        
        return persistentContainer
    }
    
    func initForgroundContext() -> NSManagedObjectContext {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    
    func initBackgroundContext() -> NSManagedObjectContext {
        let context = self.persistentContainer.newBackgroundContext()
        context.mergePolicy = NSMergePolicy.mergeByPropertyStoreTrump
        return context
    }
}



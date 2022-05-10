//
//  CoreDataStorageContextContract.swift
//  CoreDataCombineKit
//
//  Created by Ramy Sabry on 03/05/2022.
//

import CoreData

/// Represent the core data NSManagedObjectContext
public protocol CoreDataStorageContextContract {
    func getForgroundContext() -> NSManagedObjectContext?
    func getBackgroundContext() -> NSManagedObjectContext?
}

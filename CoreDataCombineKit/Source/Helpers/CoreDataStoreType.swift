//
//  CoreDataStoreType.swift
//  CoreDataCombineKit
//
//  Created by Ramy Sabry on 03/05/2022.
//

import CoreData

public enum CoreDataStoreType: String {
    case sqLiteStoreType
    case inMemoryStoreType
}

extension CoreDataStoreType {
    var value: String {
        self == .sqLiteStoreType ? NSSQLiteStoreType : NSInMemoryStoreType
    }
}

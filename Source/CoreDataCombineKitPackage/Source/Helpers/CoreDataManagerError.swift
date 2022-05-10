//
//  CoreDataManagerError.swift
//  CoreDataCombineKit
//
//  Created by Ramy Sabry on 06/05/2022.
//

import Foundation

public enum CoreDataManagerError: Error {
    case storageContextIsNil
    case objectNotFound
    case entityNameNotFound
}

public extension CoreDataManagerError {
    var message: String {
        switch self {
        case .storageContextIsNil:
            return "Storage context is not initialized, Call setup method to initialize it"
            
        case .objectNotFound:
            return "Object not found"
            
        case .entityNameNotFound:
            return "Entity name not found"
        }
    }
}

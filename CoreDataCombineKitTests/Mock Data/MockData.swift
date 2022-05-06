//
//  MockData.swift
//  CoreDataCombineKitTests
//
//  Created by Ramy Sabry on 06/05/2022.
//

import Foundation
@testable import CoreDataCombineKit

enum MockData {
    static let storeType: CoreDataStoreType = .inMemoryStoreType
    
    static let coreDataContext: CoreDataStorageContext = .init(
        fileName: "TestingDataModel",
        bundle: .main,
        storeType: storeType
    )
}

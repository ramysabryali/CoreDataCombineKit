//
//  MockData.swift
//  CoreDataCombineKitTests
//
//  Created by Ramy Sabry on 06/05/2022.
//

import Foundation
@testable import CoreDataCombineKit

enum MockData {
    static let storeType: CoreDataStoreType = .sqLiteStoreType
    
    static let bundle: Bundle = .init(for: CoreDataManagerTests.self)
    
    static let validFileName: String = "TestingDataModel"
    
    static let inValidFileName: String = "InvalidDataModelName"
    
    static let coreDataContext: CoreDataStorageContext = .init(
        fileName: validFileName,
        bundle: bundle,
        storeType: storeType
    )
}

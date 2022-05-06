//
//  CoreDataRepositoryTests.swift
//  CoreDataCombineKitTests
//
//  Created by Ramy Sabry on 06/05/2022.
//

import XCTest
@testable import CoreDataCombineKit

class CoreDataRepositoryTests: XCTestCase {
    private var sut: CoreDataRepository<User>!
    
    override func setUp() {
        super.setUp()
        sut = CoreDataRepository<User>(coreDataStorageContext: MockData.coreDataContext)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
}

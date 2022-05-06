//
//  CoreDataManagerTests.swift
//  CoreDataCombineKitTests
//
//  Created by Ramy Sabry on 06/05/2022.
//

import XCTest
@testable import CoreDataCombineKit

class CoreDataManagerTests: XCTestCase {
    private var sut: CoreDataManager!
    
    override func setUp() {
        super.setUp()
        sut = CoreDataManager.shared
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSUT_whenInitCalled_withoutCallingSetup_callingStorageContextShouldThrowError() {
        XCTAssertThrowsError(try sut.storageContext())
//        sut = CoreDataManager.shared
//
//        do {
//            // When
//            let storageContext = try sut.storageContext()
//
//            // Then
//            XCTAssertNil(storageContext)
//
//        } catch {
//            XCTAssertNotNil(error)
//        }
    }
    
//    func testSUT_whenInitCalled_withCallingSetup_callingStorageContextReturnsValue() {
//        // Given
//        let coreDataContext: CoreDataStorageContext = MockData.coreDataContext
//
//        // When
//        CoreDataManager.setup(coreDataStorageContext: coreDataContext)
//
//        // Then
//        XCTAssertNoThrow(try sut.storageContext())
//    }
    
}


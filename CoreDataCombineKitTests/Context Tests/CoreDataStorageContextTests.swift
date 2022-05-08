//
//  CoreDataStorageContextTests.swift
//  CoreDataCombineKitTests
//
//  Created by Ramy Sabry on 06/05/2022.
//

import XCTest
@testable import CoreDataCombineKit

class CoreDataStorageContextTests: XCTestCase {
    private var sut: CoreDataStorageContext!
    
    override func setUp() {
        super.setUp()
        sut = CoreDataStorageContext(
            fileName: MockData.validFileName,
            bundle: MockData.bundle,
            storeType: MockData.storeType
        )
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func testSUT_whenInitCalled_withValidInputs_forgroundContextInitializedSuccessfully() {
        // Given
        let fileName: String = MockData.validFileName
        
        // When
        sut = CoreDataStorageContext(
            fileName: fileName,
            bundle: MockData.bundle,
            storeType: MockData.storeType
        )
        
        // Then
        XCTAssertNotNil(sut.getForgroundContext())
    }
    
    func testSUT_whenInitCalled_withValidInputs_backgroundContextInitializedSuccessfully() {
        // Given
        let fileName: String = MockData.validFileName
        
        // When
        sut = CoreDataStorageContext(
            fileName: fileName,
            bundle: MockData.bundle,
            storeType: MockData.storeType
        )
        
        // Then
        XCTAssertNotNil(sut.getBackgroundContext())
    }
    
    func testSUT_whenInitCalled_withInValidInputs_forgroundContextIsNil() {
        // Given
        let fileName: String = MockData.inValidFileName
        
        // When
        sut = CoreDataStorageContext(
            fileName: fileName,
            bundle: MockData.bundle,
            storeType: MockData.storeType
        )
        
        // Then
        XCTAssertNil(sut.getForgroundContext())
    }
    
    func testSUT_whenInitCalled_withInValidInputs_backgroundContextIsNil() {
        // Given
        let fileName: String = MockData.inValidFileName
        
        // When
        sut = CoreDataStorageContext(
            fileName: fileName,
            bundle: MockData.bundle,
            storeType: MockData.storeType
        )
        
        // Then
        XCTAssertNil(sut.getBackgroundContext())
    }
}

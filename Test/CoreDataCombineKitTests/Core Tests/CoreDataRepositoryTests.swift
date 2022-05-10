//
//  CoreDataRepositoryTests.swift
//  CoreDataCombineKitTests
//
//  Created by Ramy Sabry on 06/05/2022.
//

import XCTest
import Combine
@testable import CoreDataCombineKit

class CoreDataRepositoryTests: XCTestCase {
    private var sut: CoreDataRepository<User>!
    private var cancellables: Set<AnyCancellable>!
    private var coreDataContext: CoreDataStorageContext!
    
    override func setUp() {
        super.setUp()
        cancellables = Set<AnyCancellable>()
        coreDataContext = CoreDataStorageContext(
            fileName: MockData.validFileName,
            bundle: MockData.bundle,
            storeType: MockData.storeType
        )
        sut = CoreDataRepository<User>(coreDataStorageContext: coreDataContext)
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        coreDataContext = nil
        super.tearDown()
    }
    
    func testSUT_whenCallingFetch_forFirstTime_dataShouldBeEmpty() {
        // Given
        let exp = expectation(description: "Description")
        exp.expectedFulfillmentCount = 2

        sut.fetch()
            .sink { completion in
                guard case .failure(_) = completion else {
                    exp.fulfill()
                    return
                }
                
                XCTFail()
                exp.fulfill()
            } receiveValue: { users in
                
                // Then
                XCTAssertTrue(users.isEmpty)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        waitForExpectations(timeout: 1)
    }
    
    func testSUT_whenCallingInsert_newEntityShouldBeSavedSuccessfully() {
        // Given
        let exp = expectation(description: "Description")
        exp.expectedFulfillmentCount = 2

        // When
        sut.insert { user in
            user.name = "New Name"
            user.id = UUID()
        }.sink { completion in
            guard case .failure(_) = completion else {
                exp.fulfill()
                return
            }

            XCTFail()
            exp.fulfill()

        } receiveValue: { _ in
            // Then
            exp.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }
    
    func testSUT_whenCallingDeleteAll_allEntitiesShouldBeDeleted() {
        // Given
        let exp = expectation(description: "Description")
        exp.expectedFulfillmentCount = 2

        // When
        sut.deleteAll()
            .sink { completion in
            guard case .failure(_) = completion else {
                exp.fulfill()
                return
            }

            XCTFail()
            exp.fulfill()

        } receiveValue: { _ in
            // Then
            exp.fulfill()
        }
        .store(in: &cancellables)

        waitForExpectations(timeout: 1)
    }
}

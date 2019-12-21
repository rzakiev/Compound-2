//
//  PlistDataThrowTests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 25.11.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import XCTest
@testable import Compound_2

class PlistDataThrowTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_Company_InitializingExistingCompanyDoesntThrow() {
        //Given
        let existingCompany = "МТС"
        
        //Then
        XCTAssertNoThrow(try FinancialDataManager.getCompanyData(for: existingCompany))
    }

    func test_Company_InitializingNonExistentCompanyThrowsError() {
        //Given
        let nonExistentCompany = "Gray Matter"
        
        //When
        XCTAssertThrowsError(try FinancialDataManager.getCompanyData(for: nonExistentCompany)) { error in
            XCTAssertEqual(error as? PlistParsingError, PlistParsingError.unableToGetCompanyData)
        }
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

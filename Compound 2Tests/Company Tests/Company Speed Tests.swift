//
//  Company Speed Test.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 21.12.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import XCTest
@testable import Compound_2

class Company_Speed_Test: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            
        }
    }
    
    
    func test_Company_InitializationTime() {
        self.measure {
            for company in FinancialDataManager.listOfAllCompanies() {
                let _ = Company(name: company).netIncome
            }
        }
    }
    
    func test_FinancialDataManager_FetchingCompaniesProfitFiguresTime() {
        self.measure {
            for company in FinancialDataManager.listOfAllCompanies() {
                let _ = FinancialDataManager.getNetIncome(for: company)
            }
        }
    }
    
}

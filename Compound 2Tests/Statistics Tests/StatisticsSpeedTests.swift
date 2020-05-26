//
//  StatisticsSpeedTests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 13.11.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import XCTest
@testable import Compound_2

class StatisticsSpeedTests: XCTestCase {

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

    func test_Statistics_CompaniesSortedByIndustryAndRevenueCAGRInitializationime() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let _ = Statistics.companiesSortedByIndustryAndRevenueCAGR()
        }
    }
    
    func test_Statistics_CompaniesSortedByCAGRInitializationime() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            let _ = Statistics.companiesSortedByRevenueCAGR()
        }
    }
}

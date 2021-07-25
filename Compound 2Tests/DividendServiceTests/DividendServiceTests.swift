//
//  DividendServiceTests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 30.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import XCTest
@testable import Compound_2

class DividendServiceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            let _ = MoexDividendService.groupDividendsByYear(MoexDataManager.getDividendDataLocally(forTicker: "CHMF")!.dividends!)
        }
    }

}

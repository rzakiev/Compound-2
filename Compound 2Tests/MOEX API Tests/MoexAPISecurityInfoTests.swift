//
//  MoexAPISecurityInfoTests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 28.11.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import XCTest
@testable import Compound_2

class MoexAPISecurityInfoTests: XCTestCase {

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
            // Put the code you want to measure the time of here.
        }
    }
    
    func testDepositoryRecepitFeeAvailableForAllTickers() {
        //GIVEN
        let depositoryReceiptsTradedOnMoex = MoexDataManager.getDepositoryReceiptsTradedOnMoex()
        for dr in depositoryReceiptsTradedOnMoex {
            print("\"\(dr)\",")
        }
        
        if depositoryReceiptsTradedOnMoex.isEmpty {
            XCTFail("No depository receipts information stored locally")
        }
        
        let depositoryReceiptsWithShareCount = ShareCountData.depositoryReceiptsWithShareCount()
        
        XCTAssert(depositoryReceiptsTradedOnMoex.count == depositoryReceiptsWithShareCount.count, "Difference between the list of traded depository receipts and the list of DR with a share count: \(Set(depositoryReceiptsTradedOnMoex).symmetricDifference(Set(depositoryReceiptsWithShareCount)))")
    }
}

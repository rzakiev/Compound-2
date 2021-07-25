//
//  ConstantsTest.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 03.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import XCTest

@testable import Compound_2

final class ConstantsTests: XCTestCase {
    
//    override func setUp() {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//    }
//
//    override func tearDown() {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//    }
    
    func test_ConstantTickerSymbols_TickerSymmbolsAraAvailableForAllCompanies() {
        //GIVEN
        let companiesInPlistFormat = FinancialDataManager.listOfAllCompanies().map(\.ticker)
        
        guard companiesInPlistFormat.count > 0 else {
            XCTFail()
            return
        }
        
        let companiesWithTickerSymbols = ConstantTickerSymbols.allTickerSymbols()
        
        //When
        let symmetricDifference = Set(companiesInPlistFormat).symmetricDifference(Set(companiesWithTickerSymbols))
        
        //Then
        XCTAssertTrue(symmetricDifference.count == 0, "Found discrepancy between the list of public companies and companies with a ticker symbol: \(symmetricDifference)")
    }
    
    
    
}

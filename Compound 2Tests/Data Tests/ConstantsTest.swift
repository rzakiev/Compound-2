//
//  ConstantsTest.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 03.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import XCTest

@testable import Compound_2

final class ConstantsTests: XCTest {
    
    func test_ConstantTickerSymbols_CompaniesAreIdenticalToSmartlabCompanies() {
        //GIVEN
        guard let publicCompanies = FinancialDataManager.getPublicCompanies() else { XCTFail(); return }
        let companiesWithTickerSymbol = ConstantTickerSymbols.allCompaniesWithTicker()
        
        //When
        let symmetricDifference = Set(publicCompanies).symmetricDifference(Set(companiesWithTickerSymbol))
        
        //Then
        XCTAssertTrue(symmetricDifference.count == 0, "Found discrepancy between the list of public companies and companies with a ticker symbol: \(symmetricDifference)")
    }
}

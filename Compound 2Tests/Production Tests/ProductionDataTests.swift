//
//  ProductionDataTests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 08.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import XCTest
@testable import Compound_2

class ProductionDataTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_ProductionDataManager_canListCompaniesWithProductionFigures() {
        //Given
        let companiesWithProductionFigures = ProductionDataManager.listOfAllCompanies()
        //Then
        XCTAssertFalse(companiesWithProductionFigures.count == 0)
    }
    
    func test_ProductionDataManager_companiesWithProductionFiguresAlsoHaveFinancialData() {
        let companiesWithFinancialData = FinancialDataManager.listOfAllCompanies()
        let companiesWithProductioData = ProductionDataManager.listOfAllCompanies()
        
        for company in companiesWithProductioData {
            XCTAssertNotNil(companiesWithFinancialData.first(where: {$0 == company}), "No financial data for company: \(company)")
        }
    }
    
    func test_ProductionDataManager_canGetProductionFiguresForAllCompanies() {
        //GIVEN
        let companiesWithProductioData = ProductionDataManager.listOfAllCompanies()
        
        //When
        for company in companiesWithProductioData {
            let productionFigures = ProductionDataManager.getProductionFigures(for: company)
            XCTAssertNotNil(productionFigures, "Unexpectedly found nil when fetching production figures for \(company)")
        }
    }
    
    func test_ProductionDataManager_productionFiguresAreAvailableForLastYear() {
        //GIVEN
        let companiesWithProductioData = ProductionDataManager.listOfAllCompanies()
        //When
        for company in companiesWithProductioData {
            let productionFigures = ProductionDataManager.getProductionFigures(for: company)
            for produce in productionFigures!.produce {
                let productionFiguresForLastYear = produce.values.first(where: { $0.year == Date.lastYear })
                XCTAssertNotNil(productionFiguresForLastYear, "Figures for \(produce.name) for \(company) are unavailable for \(Date.lastYear)")
            }
        }
    }
}

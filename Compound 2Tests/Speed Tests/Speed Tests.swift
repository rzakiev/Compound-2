//
//  Speed Tests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 16.08.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import XCTest
@testable import Compound_2

class Speed_Tests: XCTestCase {

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

    func testCompanyInitializationTime() {
        // This is an example of a performance test case.
        self.measure {
            let sber = Company(name: "Сбербанк")
            if sber.revenue != nil {
                for figure in sber.revenue! {
                    print(String(figure.year) + " : " + String(figure.value))
                }
            }
        }
    }
    
    func test_FinancialChartList_InitializationTime() {
        self.measure {
            let _ = FinancialChartList(company: .init(name: "", ticker: ""))
        }
    }

    func testCAGRCalculationSpeed() {
        self.measure {
            let _ = Statistics.companiesSortedByIndustryAndRevenueCAGR()
        }
    }
    
    func testQuoteServiceSpeed() {
        let quoteExpectation = expectation(description: "Quote service is fetching a quote")
        
        self.measure {
            //Given
            
            let companies = FinancialDataManager.listOfAllCompanies().map(\.name)
            
            //When
            for companyName in companies {
                DispatchQueue.global(qos: .background).async {
                    MoexQuoteService.shared.getQuoteAsync(for: companyName) { quote in
                        XCTAssertNotNil(quote?.quote)
                        print("Ordinary share price: \(quote?.quote ?? -1)")
                    }
                }
            }
        }
        
        quoteExpectation.fulfill()
        waitForExpectations(timeout: 19, handler: nil)
    }
    
    func testCompanyInitializationSpeed() {
        self.measure {
            let allComapnies = FinancialDataManager.listOfAllCompanies().map(\.name)
            
            for company in allComapnies {
                let _ = Company(name: company)
            }
        }
    }
    
    func testDividendGrowthSpeed() {
        self.measure {
            let _ = Statistics.grossGrowthRateForAllCompanies(for: .dividend)
        }
    }
}

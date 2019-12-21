//
//  InvestmentTest.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 09.11.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import XCTest
@testable import Compound_2

class InvestmentTest: XCTestCase {
    
    private let allCompanies = FinancialDataManager.listOfAllCompanies()
    
    override class func setUp() {
        
    }
    
    override class func tearDown() {
        
    }

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_Investment_AllCompaniesAreCheckableAsDividendStory() {
        
        for company in allCompanies {
            let sut = Investment(company: company, type: .dividendPlay)
            let verdict = sut.checkInvestmentThesis()
            print(verdict.analysis)
        }
    }
    
    func test_Investment_AllCompaniesAreCheckableAsGrowthStories() {
        
        for company in allCompanies {
            let sut = Investment(company: company, type: .growthPlay)
            let verdict = sut.checkInvestmentThesis()
            print(verdict.analysis)
        }
    }

    func test_Investment_YandexIsNotDividendStory() {
        let sut = Investment(company: "Яндекс", type: .dividendPlay)
        let investmentVerdict = sut.checkInvestmentThesis()
        XCTAssertFalse(investmentVerdict.isGoodInvestment)
    }
    
    func test_Investment_MtsIsDividendStory() {
        let sut = Investment(company: "МТС", type: .dividendPlay)
        let investmentVerdict = sut.checkInvestmentThesis()
        XCTAssertTrue(investmentVerdict.isGoodInvestment)
    }
    
    
    
    

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

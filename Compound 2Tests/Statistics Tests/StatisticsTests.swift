//
//  StatisticsTests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 05.10.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

import XCTest
@testable import Compound_2



class StatisticsTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRevenueCAGRCalculation() {
        let _ = Statistics.companiesSortedByRevenueCAGR()
    }
    
    func testCompaniesSortedByRevenueCAGRandIndustry() {
        let _ = Statistics.companiesSortedByIndustryAndRevenueCAGR()
    }
    
    func testCAGRCalculationForIndividualCompanies() {
        
        let companies = ["Сбербанк", "Яндекс", "АФК Система", "МТС"]
        
        for company in companies {
            print("\(company) revenue cagr: \(Statistics.getRevenueCAGR(for: company))")
        }
        
        
    }
    
}

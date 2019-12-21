//
//  MultipliersTests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 15.10.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

import XCTest
@testable import Compound_2



class MultipliersTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testEVEBITDACalculation() {
        let companies = ["Сбербанк", "Яндекс", "МТС", "АФК Система"]
        
        for company in companies {
            if let evEBITDA = Multipliers.evEBITDA(for: company) {
                print("\(company) EV/EBITDA: \(evEBITDA)")
            } else {
                print("Unable to fetch EV/EBITDA for \(company)")
            }
        }
    }
    
//    func testAsyncEVEBITDACalculationSpeed() {
//
//
//
//            let publicCompanies = try! FinancialDataManager.getSmartlabLinks().map({$0.key})
//
//            DispatchQueue.main.async {
////                let numbers = Multipliers.ev(publicCompanies)
////                print(numbers)
//            }
//
//
//
//        //        self.measure {
//        //
//        //            DispatchQueue.main.async {
//        //                print()
//        //            }
//        //        }
//
//    }
}

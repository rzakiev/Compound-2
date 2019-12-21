//
//  QuoteServiceTests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 02/10/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation


import Foundation

import XCTest
@testable import Compound_2

class QuoteServiceTests: XCTestCase {
    
    private let companiesWithPreferredShares = ["Сбербанк", "Ростелеком", "Россети", "Татнефть"]
    
    func testPublicCompaniesHaveLinksForQuoteSource() {
        //Given
        let companies = FinancialDataManager.listOfAllCompanies()
        
        //When
        for companyName in companies {
            let company = Company(name: companyName)
            if company.isPublic {
                //Then
                XCTAssertNotNil(try? FinancialDataManager.getSmartlabLinks()[company.name])
            }
        }
    }
    
    func testQuotesAreFetchableForAllPublicCompanies() {
        //Given
        let companies = FinancialDataManager.listOfAllCompanies()
        let quoteExpectation = expectation(description: "Quote service is fetching a quote")
        
        for companyName in companies {
            let company = Company(name: companyName)
            QuoteService.shared.asynchronouslyGetQuote(for: company.name) { (ordinary, preferred) in
                XCTAssertNotNil(ordinary, "Ordinary price for \(companyName): \(ordinary ?? -1)")
            }
        }
        quoteExpectation.fulfill()
        waitForExpectations(timeout: 19, handler: nil)
    }
    
    func testBothQuotesAreFetchableForCompaniesWithPreferredShares() {
        //Given
        let quoteExpectation = expectation(description: "Quote service is fetching a quote")
        
        //When
        for company in companiesWithPreferredShares {
            QuoteService.shared.asynchronouslyGetQuote(for: company) { (ordinary, preferred) in
                //Then
                XCTAssertNotNil(ordinary)
                XCTAssertNotNil(preferred)
                print("\(company): ordinary share price:\(ordinary ?? -1); preferred share price:\(preferred ?? -1)")
            }
        }
        
        quoteExpectation.fulfill()
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testPreferredQuoteIsNotFetchedForCompaniesWithNoPreferredShares() {
        //Given
        let allCompanies = try! FinancialDataManager.getSmartlabLinks().map({$0.key})
        let companiesWithoutPreferredShares = allCompanies.filter({ companiesWithPreferredShares.contains($0) == false })
        let quoteExpectation = expectation(description: "Quote service is fetching a quote")
        
        //When
        for company in companiesWithoutPreferredShares {
            QuoteService.shared.asynchronouslyGetQuote(for: company) { (ordinary, preferred) in
                //Then
                XCTAssertNotNil(ordinary, "Did not fetch ordinary price for: \(company)")
                XCTAssertNil(preferred, "Did fetch preferred price for: \(company)")
            }
        }
        
        quoteExpectation.fulfill()
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func testMarketCapCalculationInCompanyAndInQuoteService() {
        //Given
        let quoteExpectation = expectation(description: "Quote service is fetching a quote")
        
        for companyName in ["Сбербанк", "Яндекс", "МТС", "АФК Система"] {
            let company = Company(name: companyName)
            let marketCap2 = QuoteService.shared.fetchMarketCapitalization(for: companyName)
            
            company.fetchMarketCapitalization { marketCap in
                print("\(companyName) market cap1: \(marketCap), 2: \(marketCap2 ?? -1)")
                XCTAssert(marketCap == marketCap2, "Market Cap 1: \(marketCap), 2: \(marketCap2 ?? -1)")
                
            }
        }
        
        quoteExpectation.fulfill()
        waitForExpectations(timeout: 20, handler: nil)
    }
    
}




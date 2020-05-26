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
    
    private let companiesWithPreferredShares = ConstantTickerSymbols.companiesWithPreferredShares
    
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
            QuoteService.shared.getQuoteAsync(for: company.name) { quote in
//                print("Company: \(quote.companyName), quote: \(quote.ordinaryShareQuote)")
                XCTAssertNotNil(quote?.ordinaryShareQuote, "Ordinary price for \(companyName): \(quote?.ordinaryShareQuote ?? -1)")
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
            QuoteService.shared.getQuoteAsync(for: company) { quote in
                //Then
                XCTAssertNotNil(quote?.ordinaryShareQuote)
                XCTAssertNotNil(quote?.preferredShareQuote)
                print("\(company): ordinary share price:\(quote?.ordinaryShareQuote ?? -1); preferred share price:\(quote?.preferredShareQuote ?? -1)")
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
            QuoteService.shared.getQuoteAsync(for: company) { quote in
                //Then
                XCTAssertNotNil(quote?.ordinaryShareQuote, "Did not fetch ordinary price for: \(company)")
                XCTAssertNil(quote?.preferredShareQuote, "Did fetch preferred price for: \(company)")
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
            let marketCap2 = MarketCapitalization.calculateMarketCapitalization(for: companyName)
            
            company.fetchMarketCapitalization { marketCap in
                print("\(companyName) market cap1: \(marketCap), 2: \(marketCap2 ?? -1)")
                XCTAssert(marketCap == marketCap2, "Market Cap 1: \(marketCap), 2: \(marketCap2 ?? -1)")
            }
        }
        
        quoteExpectation.fulfill()
        waitForExpectations(timeout: 20, handler: nil)
    }
    
    func test_QuoteService_OrdinaryQuoteFetchingSpeed() {
        self.measure {
            let _ = QuoteService.shared.getQuote(for: "МТС")
        }
    }
    
    func test_QuoteService_OrdinaryAndPreferredQuoteFetchingSpeed() {
        self.measure {
            let _ = QuoteService.shared.getQuote(for: "Сбербанк")
        }
    }
    
    func test_QuoteService_FetchingAllQuotes() {
        self.measure {
            let _ = QuoteService.shared.getAllMoexQuotes()
        }
    }
}




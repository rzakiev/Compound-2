//
//  DataTests.swift
//  Compound 2Tests
//
//  Created by Robert Zakiev on 25/09/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

///These are tests for ensuring that various static data about companies is sufficient: for example, if there's a plist file with some company's financial data, this company should also be available in the the Constants.industries constant
///

import Foundation

import XCTest
@testable import Compound_2

class PlistDataTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //MARK: - Testing plist files content
    func testNumberOfCompaniesInPlistFormatIsEqualToCompaniesInConstantStruct() {
        //Given
        let listOfPlistFiles = FinancialDataManager.listOfAllCompanies()
        var companiesInIndustryConstant = [String]()
        
        //When
        var numberOfValuesInIndustryConstant: Int = 0
        for industry in CorporateConstants.industries {
            for company in industry.companies {
                numberOfValuesInIndustryConstant += 1
                companiesInIndustryConstant.append(company)
            }
        }
        
        //Then
        XCTAssert(listOfPlistFiles.count == numberOfValuesInIndustryConstant, "Difference between the list of plist files and companies in the IndustryConstant struct: \(Set(listOfPlistFiles).symmetricDifference(Set(companiesInIndustryConstant)))")
    }
    
    func testAllPlistsAreParseable() {
        //Given
        let allCompanies = FinancialDataManager.listOfAllCompanies()
        
        //When
        for company in allCompanies {
            let _ = Company(name: company)
            //Then
            XCTAssertNotNil(try? FinancialDataManager.getCompanyData(for: company))
        }
    }
    
    func testSmartlabLinksPlistIsParseable() {
        XCTAssertNoThrow(try FinancialDataManager.getSmartlabLinks())
    }
    
    func testNumberOfOrdinarySharesIsAvailableForPublicCompanies() {
        //Given
        let allPublicCompanies = try! FinancialDataManager.getSmartlabLinks().map({ $0.key})
        let companiesWithPreferredShares = ["Сбербанк", "Ростелеком", "Россети", "Татнефть"]

        //When
        for company in allPublicCompanies {
            let shares = try! FinancialDataManager.numberOfSharesFor(company: company)
            if companiesWithPreferredShares.contains(company) {
                //Then
                XCTAssertNotNil(shares.numberOfOrdinaryShares)
                XCTAssertNotNil(shares.numberOfPreferredShares)
            } else {
                XCTAssertNotNil(shares.numberOfOrdinaryShares)
                XCTAssertNil(shares.numberOfPreferredShares)
            }
        }
    }
    
    func testEachCompanyHasRevenueFigures() {
        //Given
        let allCompanies = FinancialDataManager.listOfAllCompanies()
        
        //When
        for company in allCompanies {
            //THen
            XCTAssertNotNil(FinancialDataManager.getRevenue(for: company))
        }
    }
    
    func testPublicCompaniesHaveQuoteSourceLinkAndSharesIssued() {
        //Given
        let publicCompanies = try! FinancialDataManager.getSmartlabLinks().map({$0.key})
        //Wheb
        for company in publicCompanies {
            //Then
            XCTAssertNotNil(try? FinancialDataManager.numberOfSharesFor(company: company)) 
        }
    }
    
    func testNumberOfSharesForAllCompaniesIsNotNil() {
        //Given
        let publicCompanies = try! FinancialDataManager.getSmartlabLinks().map({$0.key})
        
        //When
        for company in publicCompanies {
            if let numberOfShares = try? FinancialDataManager.numberOfSharesFor(company: company) {
                //Then
                XCTAssert(numberOfShares.numberOfOrdinaryShares > 0)
                if numberOfShares.numberOfPreferredShares != nil { XCTAssert(numberOfShares.numberOfPreferredShares! > 0) }
            }
            else {
                XCTFail() //No shares for a company with a quote link should fail
            }
        }
    }
    
    func testNoPlistsWithIdenticalData() {
        //Given
        let companies  = FinancialDataManager.listOfAllCompanies()
        
        //When
        for i in companies.indices {
            let possibleDuplicate = companies[i]
            for company in companies {
                if possibleDuplicate != company { // no need to compare same company to itself
                    //Then
                    XCTAssertFalse ((try! FinancialDataManager.getCompanyData(for: company)) ==
                        (try! FinancialDataManager.getCompanyData(for: possibleDuplicate)),
                         "Found diplicate data for \(company) and \(possibleDuplicate)")

                }
            }
        }
    }
    
    func test_AllSubDirectoriesAreAvailable() {
        XCTAssertTrue(FinancialDataManager.resourceIsAvailable(at: FinancialDataManager.quoteLinksSubdirectory, named: "SmartlabLinks", ofType: "plist"))
        XCTAssertTrue(FinancialDataManager.resourceIsAvailable(at: FinancialDataManager.numberOfSharesIssuedSubdirectory, named: "NumberOfSharesIssued", ofType: "plist"))
        XCTAssertTrue(FinancialDataManager.resourceIsAvailable(at: FinancialDataManager.financialStatementsSubdirectory, named: "МТС", ofType: "plist"))
        XCTAssertTrue(FinancialDataManager.resourceIsAvailable(at: FinancialDataManager.ecosystemImagesSubdirectory, named: "Сбербанк", ofType: "png"))
        XCTAssertTrue(FinancialDataManager.resourceIsAvailable(at: FinancialDataManager.productionFiguresSubdirectory, named: "Сегежа", ofType: "plist"))
        XCTAssertTrue(FinancialDataManager.resourceIsAvailable(at: FinancialDataManager.tradingViewLinksSubdirectory, named: "TradingViewLinks", ofType: "plist"))
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}

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
        let companiesWithPreferredShares = ["Сбербанк", "Ростелеком", "Россети"]
        
        //When
        for company in allPublicCompanies {
            let shares = try! FinancialDataManager.numberOfSharesFor(company: company)
            if companiesWithPreferredShares.contains(company) {
                //Then
                XCTAssertNotNil(shares.numberOfOrdinaryShares)
                XCTAssertNotNil(shares.numberOfPreferredShares)
            } else {
                XCTAssertNotNil(shares.numberOfOrdinaryShares)
                XCTAssertNil(shares.numberOfPreferredShares, "No preferred shares for \(company)")
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
    
    func test_FinancialDataManager_NumberOfSmartlabLinksIsEqualToNumberOfCompaniesInSharesCount() {
        guard let plistPath = Bundle.main.path(forResource: "NumberOfSharesIssued", ofType: "plist", inDirectory: "Corporate Resources/NumberOfSharesIssued") else {
            Logger.log(error: "Unable to load the plist file containing the number of shares")
            //            throw PlistParsingError.unableToLoadDataAt("Corporate Resources/NumberOfSharesIssued")
            XCTFail()
            return
        }
        
        guard let plistData = FileManager.default.contents(atPath: plistPath) else {
            Logger.log(error: "unableToLoadDataAt \(plistPath)")
            //            throw PlistParsingError.unableToLoadDataAt(plistPath)
            XCTFail()
            return
        }
        
        guard let plistObject = try? PropertyListSerialization.propertyList(from: plistData, options:PropertyListSerialization.ReadOptions(), format:nil) else {
            Logger.log(error: "Couldn't serialize a plist file")
            //            throw PlistParsingError.unableToSerializeObject
            XCTFail()
            return
        }
        
        guard let sharesIssued = plistObject as? [String: NSNumber] else {
            Logger.log(error: "couldn't downcast the plist object with shares count as [String: String]")
            //            throw PlistParsingError.unableToDowncastObjectiveCObjectAsSwiftEntity
            XCTFail()
            return
        }
        
        let publicCompanies = try! FinancialDataManager.getSmartlabLinks().map({$0.key})
        let numberOfCompaniesWithSharesCount = sharesIssued.filter({$0.key.suffix(2) != "-п"}).count
        
        XCTAssertTrue(publicCompanies.count == numberOfCompaniesWithSharesCount, "Difference: \(Set(publicCompanies).symmetricDifference(sharesIssued.filter({$0.key.suffix(2) != "-п"}).map({$0.key} )))")
    }
    
    func testPublicCompaniesHaveQuoteSourceLinkAndSharesIssued() {
        //Given
        let publicCompanies = try! FinancialDataManager.getSmartlabLinks().map({$0.key})
        
        //Wheb
        for company in publicCompanies {
            //Then
            XCTAssertNotNil(try? FinancialDataManager.numberOfSharesFor(company: company), "\(company) has no number of shares")
            XCTAssertNotNil(try? FinancialDataManager.getSmartlabLinks()[company], "\(company) has no smartlab link")
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
    
    func test_FinancialDataManager_AllFinancialIndicatorsAreAvailableForLastYear() {
        //Given
        for company in FinancialDataManager.listOfAllCompanies() {
            //When
            let company = Company(name: company)
            
            if company.revenue != nil {
                //Then
                let lastYearRevenue = company.revenue?.first(where: { $0.year == Date.lastYear })
                XCTAssertNotNil(lastYearRevenue, "Revenue is unavailable for \(company.name) for \(Date.lastYear))")
            }
            if company.netIncome != nil {
                //Then
                let lastYearIncome = company.netIncome?.first(where: { $0.year == Date.lastYear })
                XCTAssertNotNil(lastYearIncome, "Net Income is unavailable for \(company.name) for \(Date.lastYear))")
            }
            
            if company.dividends != nil {
                //Then
                let lastYearDividends = company.dividends?.first(where: { $0.year == Date.lastYear })
                XCTAssertNotNil(lastYearDividends, "Dividends are unavailable for \(company.name) for \(Date.lastYear))")
            }
            
            if company.operatingIncome != nil {
                //Then
                let lastYearOperatingIncome = company.operatingIncome?.first(where: { $0.year == Date.lastYear })
                XCTAssertNotNil(lastYearOperatingIncome, "Operating Income is unavailable for \(company.name) for \(Date.lastYear))")
            }
            
            if company.debtToEBITDA != nil {
                //Then
                let lastYearNetDebt = company.debtToEBITDA?.first(where: { $0.year == Date.lastYear })
                XCTAssertNotNil(lastYearNetDebt, "Net debt is unavailable for \(company.name) for \(Date.lastYear))")
            }
        }
    }
    
    func test_FinancialDataManager_AllFinancialIndicatorsHaveIdenticalCount() {
        //Given
        for company in FinancialDataManager.listOfAllCompanies() {
            let company = Company(name: company)
            
            //When
            for indicator in company.availableIndicators() {
                for comparedIndicator in company.availableIndicators() {
                    if comparedIndicator != indicator {
                        guard let lhs = company.chartValues(for: indicator)  else { XCTFail(); return }
                        guard let rhs = company.chartValues(for: comparedIndicator)  else { XCTFail(); return }
                        
                        let lhsUntilThisYear = lhs[lhs.startIndex...(lhs.firstIndex(where: { $0.year == Date.lastYear }) ?? lhs.endIndex - 1 )]
                        let rhsUntilThisYear = rhs[lhs.startIndex...(rhs.firstIndex(where: { $0.year == Date.lastYear }) ?? rhs.endIndex - 1)]
                        
                        //Then
                        XCTAssertEqual(lhsUntilThisYear.count, rhsUntilThisYear.count, "\(company.name): \(comparedIndicator.title) has \(rhs.count) values while \(indicator) has \(lhs.count) values.")
                    }
                }
            }
        }
    }
    
    func test_FinancialDataManager_YearValuesAreInSuccessiveOrder() {
        //Given
        for company in FinancialDataManager.listOfAllCompanies() {
            let company = Company(name: company)
            
            //When
            for financialIndicator in company.availableIndicators() {
                let values = company.chartValues(for: financialIndicator)!.map({ $0.year })
                for i in 1..<values.count {
                    //Then
                    XCTAssertEqual(values[i], values[i-1] + 1, "Incorrect order of year values for \(financialIndicator) for \(company). \(values[i]) is not larger than \(values[i-1]) by 1")
                }
            }
        }
    }
}

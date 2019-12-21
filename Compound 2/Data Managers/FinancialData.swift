//
//  FinancialData.swift
//  Compound 2
//
//  Created by Robert Zakiev on 04.08.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

struct FinancialDataManager {
    
    static func listOfAllCompanies() -> [String] {
        var allCompanies = Bundle.main.paths(forResourcesOfType: "plist", inDirectory: "Corporate Resources/FinancialStatements")
        
        for i in 0..<allCompanies.count {
            allCompanies[i] = String(allCompanies[i].suffix(from: allCompanies[i].range(of: "FinancialStatements/")!.upperBound).dropLast(6)) //dropping '.plist' from the file name
        }
        return allCompanies
    }
    
    static func getSmartlabLinks() throws -> [String: String] {
        guard let plistPath = Bundle.main.path(forResource: "SmartlabLinks", ofType: "plist", inDirectory: quoteLinksSubdirectory) else {
            Logger.log(error: "unableToLoadPathAt \"Corporate Resources/QuoteLinks\"")
            throw PlistParsingError.unableToLoadDataAt("Corporate Resources/QuoteLinks")
        }
        
        guard let plistData = FileManager.default.contents(atPath: plistPath) else {
            Logger.log(error: "unableToLoadDataAt \(plistPath)")
            throw PlistParsingError.unableToLoadDataAt(plistPath)
        }
        
        guard let plistObject = try? PropertyListSerialization.propertyList(from: plistData, options:PropertyListSerialization.ReadOptions(), format:nil) else {
            Logger.log(error: "Couldn't serialize a plist file")
            throw PlistParsingError.unableToSerializeObject
        }
        
        guard let smartlabLinks = plistObject as? [String: String] else {
            Logger.log(error: "couldn't downcast plist object as [String: String]")
            throw PlistParsingError.unableToDowncastObjectiveCObjectAsSwiftEntity
        }
        return smartlabLinks
    }
}

//MARK: - Get Custom Indiactors
extension FinancialDataManager {
    static func getOperatingIncome(for company: String) -> (type: OperatingIncomeType, values: [(year: Int, value: Double)])? {
        
        guard var plistData = try? fetchPlistData(for: company) else {
            Logger.log(error: "Unable to load data for \(company)")
            return nil
        }
        
        let parsedData = parseData(from: &plistData, for: company)
        if let ebitda = parsedData.ebitda {
            return (.EBITDA, ebitda)
        } else if let oibda = parsedData.oibda {
            return (.OIBDA, oibda)
        } else {
            return nil
        }
    }
    
    static func getNetDebt(for company: String) -> [(year: Int, value: Double)]? {
        
        guard var plistData = try? fetchPlistData(for: company) else {
            Logger.log(error: "Unable to load data for \(company)")
            return nil
        }
        
        let parsedData = parseData(from: &plistData, for: company)
        return parsedData.netDebt
    }
    
    static func getRevenue(for company:String) -> [(year: Int, value: Double)]? {
        
        guard var plistData = try? fetchPlistData(for: company) else {
            Logger.log(error: "Unable to load data for \(company)")
            return []
        }
        
        return parseData(from: &plistData, for: company).revenue ?? nil
    }
    
    static func getNetIncome(for company: String) -> [(year: Int, value: Double)]? {
        guard var plistData = try? fetchPlistData(for: company) else {
            Logger.log(error: "Unable to load data for \(company)")
            return []
        }
        
        return parseData(from: &plistData, for: company).netIncome ?? []
    }
}

//MARK: - Fetching Number of Shares
extension FinancialDataManager {
    static func numberOfSharesFor(company: String) throws -> (numberOfOrdinaryShares: Int, numberOfPreferredShares: Int?) {
        guard let plistPath = Bundle.main.path(forResource: "NumberOfSharesIssued", ofType: "plist", inDirectory: "Corporate Resources/NumberOfSharesIssued") else {
            Logger.log(error: "Unable to load the plist file containing the number of shares")
            throw PlistParsingError.unableToLoadDataAt("Corporate Resources/NumberOfSharesIssued")
        }
        
        guard let plistData = FileManager.default.contents(atPath: plistPath) else {
            Logger.log(error: "unableToLoadDataAt \(plistPath)")
            throw PlistParsingError.unableToLoadDataAt(plistPath)
        }
        
        guard let plistObject = try? PropertyListSerialization.propertyList(from: plistData, options:PropertyListSerialization.ReadOptions(), format:nil) else {
            Logger.log(error: "Couldn't serialize a plist file")
            throw PlistParsingError.unableToSerializeObject
        }
        
        guard let sharesIssued = plistObject as? [String: NSNumber] else {
            Logger.log(error: "couldn't downcast the plist object with shares count as [String: String]")
            throw PlistParsingError.unableToDowncastObjectiveCObjectAsSwiftEntity
        }
        
        if let numberOfOrdinaryShares = sharesIssued[company] {
            if let numberOfPreferredShares = sharesIssued[company + "-п"] { //preferred shares contain -п at the end
                return (Int(truncating: numberOfOrdinaryShares), Int(truncating: numberOfPreferredShares))
            } else {
                return (Int(truncating: numberOfOrdinaryShares), nil)
            }
        } else {
            Logger.log(error: "Unable to find the number of shares issued by \(company)")
            throw PlistParsingError.unableToFindNumberOfSharesIssued
        }
    }
}

extension FinancialDataManager {
    static func getCompanyData(for company: String) throws -> FinancialIndicators {
        guard var plistData = try? fetchPlistData(for: company) else {
            throw PlistParsingError.unableToGetCompanyData
        }
        return parseData(from: &plistData, for: company)
    }
}

//MARK: - Working with the file system
private extension FinancialDataManager {
    
    //Fetching the plist file with a company's financial indicators
    private static func fetchPlistData(for company: String) throws -> Data? {
        guard let plistPath = Bundle.main.path(forResource: company, ofType: "plist",
                                               inDirectory: "Corporate Resources/FinancialStatements")
        else {
            throw PlistParsingError.unableToGetPlistPathFor(company)
        }
        
        guard let plistData = FileManager.default.contents(atPath: plistPath) else {
            Logger.log(error: "Couldn't load the plist data from path: \(plistPath)")
            throw PlistParsingError.unableToLoadDataAt(plistPath)
        }
        return plistData
    }
    
    //trying to parse the data from the plist file
    private static func parseData(from plist: inout Data, for company: String) -> FinancialIndicators {
        let plistObject = try! PropertyListSerialization.propertyList(from: plist, options:PropertyListSerialization.ReadOptions(), format:nil)
        //Cast plistObject - If expected data type is Dictionary
        var plistDict = plistObject as! Dictionary<String, AnyObject>
        //If the data is successfully parsed, proceed to replace NSNumbers and NSMutableStrings with Ints and Strings
        return convertDictIntoFinancialIndicatorsStruct(financialIndicatorsDictionary: &plistDict)
    }
}

//MARK: - Transforming plist dictionaries into proper Swift dictionaries
private extension FinancialDataManager {
    
    static func convertDictIntoFinancialIndicatorsStruct(financialIndicatorsDictionary: inout Dictionary<String, AnyObject>) -> FinancialIndicators {
        
        var revenue: [(year: Int, value: Double)]?
        var ebitda: [(year: Int, value: Double)]?
        var oibda: [(year: Int, value: Double)]?
        var netIncome: [(year: Int, value: Double)]?
        var freeCashFlow: [(year: Int, value: Double)]?
        var dividends: [(year: Int, value: Double)]?
        var netDebt: [(year: Int, value: Double)]?
        var numberOfOrdinaryShares: Int?
        var numberOfPreferredShares: Int?
        var dividendPolicy: String?
        var annualReports: [(year: Int, url: String)]?
        var presentations: [(year: Int, url: String)]?
        var competition: CompetitionType?
        var quoteURL: String?
        
        var customIndicators = [String: [(year: Int, value: Double)]] ()
        
        for (key, value) in financialIndicatorsDictionary {
            switch key {
            case "Revenue":
                revenue = convertIntoSwiftArray(value as! NSMutableArray)
            case "Net Income":
                netIncome = convertIntoSwiftArray(value as! NSMutableArray)
            case "Dividends":
                dividends = convertIntoSwiftArray(value as! NSMutableArray)
            case "Net Debt":
                netDebt = convertIntoSwiftArray(value as! NSMutableArray)
            case "Free Cash Flow":
                freeCashFlow = convertIntoSwiftArray(value as! NSMutableArray)
            case "EBITDA":
                ebitda = convertIntoSwiftArray(value as! NSMutableArray)
            case "OIBDA":
                oibda = convertIntoSwiftArray(value as! NSMutableArray)
            case "Ordinary Shares":
                numberOfOrdinaryShares = Int(truncating: value as! NSNumber)
            case "Preferred Shares":
                numberOfPreferredShares = Int(truncating: value as! NSNumber)
            case "Annual Reports":
                annualReports = [(year: Int, url: String)]()
                for (year, url) in value as! NSMutableDictionary {
                    annualReports!.append((Int(year as! String)!, url as! String))
                }
            case "Presentations":
                presentations = [(year: Int, url: String)]()
                for (year, url) in value as! NSMutableDictionary {
                    presentations!.append((Int(year as! String)!, url as! String))
                }
            case "QuoteSource":
                quoteURL = String(value as! NSMutableString)
            case "Dividend Policy":
                dividendPolicy = String(value as! NSMutableString)
            case "Competition":
                switch value as! String {
                case "Низкая":
                    competition = .low
                case "Средняя":
                    competition = .medium
                case "Высокая":
                    competition = .high
                case "Монополист":
                    competition = .monopoly
                default:
                    Logger.log(error: "Encountered an unknown competition type: \(value as! String)")
                }
            default:
                customIndicators[key] = convertIntoSwiftArray(value as! NSMutableArray)
                Logger.log(operation: "Encountered an unknown key while parsing the plist: \(key)")
            }
        }
        
        let financialIndicators = FinancialIndicators(revenue: revenue,
                                                      ebitda: ebitda,
                                                      oibda: oibda,
                                                      netIncome: netIncome,
                                                      freeCashFlow: freeCashFlow,
                                                      dividends: dividends,
                                                      netDebt: netDebt,
                                                      numberOfOrdinaryShares: numberOfOrdinaryShares,
                                                      numberOfPreferredShares: numberOfPreferredShares,
                                                      dividendPolicy: dividendPolicy,
                                                      annualReports: annualReports,
                                                      presentations: presentations,
                                                      competition: competition,
                                                      quoteURL: quoteURL,
                                                      customIndicators: customIndicators.isEmpty ? nil : customIndicators)
        
        return financialIndicators
    }
    
    //Converting NSMutableArrays into Swift arrays contating tuples with financial indicators value
     static func convertIntoSwiftArray(_ objectiveCArray: NSMutableArray) -> [(year: Int, value: Double)] {
        var financialIndicatorsArray = [(year: Int, value: Double)]()
        for yearAndValue in objectiveCArray {
            let swiftString = String(yearAndValue as! NSMutableString)
            let year = Int(swiftString.prefix(4))! //the first four characters are the year
            let value = Double(swiftString.suffix(swiftString.count - 5))!
            financialIndicatorsArray.append((year, value))
        }
        return financialIndicatorsArray
    }
}

extension FinancialDataManager {
    static func resourceIsAvailable(at path: String, named name: String, ofType type: String) -> Bool {
        guard let _ = Bundle.main.path(forResource: name, ofType: type, inDirectory: path) else {
            return false
        }
        
        return true
    }
}

extension FinancialDataManager {
//    static func getEcosystemImagesPath() -> String? {
//        
//        
//        if FinancialDataManager.resourceIsAvailable(at: FinancialDataManager.financialDataDirectory + FinancialDataManager.ecosystemImagesSubdirectory,
//                                                    named: company,
//                                                    ofType: ".png") {
//            return Bundle.main.path(forResource: company,
//                                    ofType: ".png",
//                                    inDirectory: FinancialDataManager.financialDataDirectory + FinancialDataManager.ecosystemImagesSubdirectory)
//        } else {
//            return nil
//        }
//    }
}

extension FinancialDataManager {
    static let financialDataDirectory = "Corporate Resources"
    
    static let quoteLinksSubdirectory = financialDataDirectory + "/QuoteLinks"
    static let financialStatementsSubdirectory = financialDataDirectory + "/FinancialStatements"
    static let ecosystemImagesSubdirectory = financialDataDirectory + "/Ecosystems"
    static let numberOfSharesIssuedSubdirectory = financialDataDirectory +  "/NumberOfSharesIssued"
    static let productionFiguresSubdirectory = financialDataDirectory +  "/ProductionFigures"
    static let tradingViewLinksSubdirectory = financialDataDirectory +  "/TradingViewLinks"
}

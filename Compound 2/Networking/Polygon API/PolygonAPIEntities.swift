//
//  PolygonAPIEntities.swift
//  PolygonAPIEntities
//
//  Created by Robert Zakiev on 31.07.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation

///Houses financial data for some company retrieved via API
struct PolygonData: Codable, FinancialData {
    let ticker: String
    let values: [String : [FinancialFigure]]
}

extension PolygonDataService {
    
    struct RequestPreferences {
        let type: TimeframeType
        let sortBy: SortingParameter
    }
    
    enum TimeframeType: String {
        case Y, YA, Q, QA, T, TA
    }
    
    enum SortingParameter: String {
        case calendarDate
    }
}

extension PolygonDataService {
    ///Entity that is decoded from the response of this endpoint: https://api.polygon.io/v2/reference/financials/AAPL
    struct PolygonFinancialDataAPIResponse: Codable {
        let status: String?
        let results: [PolygonFinancialResult]
        
        struct PolygonFinancialResult: Codable {
            let ticker: String
            let calendarDate: String
            let revenuesUSD: Double
            let netIncome: Double
            let freeCashFlow: Double
            let dividendsPerBasicCommonShare: Double
            
            func calendarYear() -> Int? {
                let dateComponents = calendarDate.split(separator: "-").map({ String($0) })
                guard let year = dateComponents[safe: 0] else {
                    Logger.log(error: "PolygonFinancialDataAPIResponse: unable to parse the year in \(calendarDate)")
                    return nil
                }
                return Int(year)
            }
        }
        
        ///Converts an instance of `PolygonFinancialDataAPIResponse` into an instance of `PolygonData`
        func convertToPolygonData() -> PolygonData? {
            
            var financialData = [String : [FinancialFigure]]()
            financialData["revenue"] = []
            financialData["netIncome"] = []
            financialData["freeCashFlow"] = []
            financialData["dividendsPerBasicCommonShare"] = []
            
            guard results.count > 0 else {
                Logger.log(error: "No results in PolygonFinancialDataAPIResponse: \(self)")
                return nil
            }
            
            guard let ticker = results.first?.ticker else {
                Logger.log(error: "No ticker in PolygonFinancialDataAPIResponse: \(self)")
                return nil
            }
            
            for result in results {
                guard let year = result.calendarYear() else {
                    Logger.log(error: "Not saving the following date due to inability to parse the year: \(result)")
                    continue
                }
                
                financialData["revenue"]?.append(.init(year: year, value: result.revenuesUSD, currency: .USD))
                financialData["netIncome"]?.append(.init(year: year, value: result.netIncome, currency: .USD))
                financialData["freeCashFlow"]?.append(.init(year: year, value: result.freeCashFlow, currency: .USD))
                financialData["dividendsPerBasicCommonShare"]?.append(.init(year: year, value: result.dividendsPerBasicCommonShare, currency: .USD))
            }
            
            return .init(ticker: ticker, values: financialData)
        }
    }
}

///Entities for the new endpoint (https://api.polygon.io/vX/reference/financials?)
/*
 struct RequestPreferences {
     let timeframe: TimeFrame
     let order: Order
     let sortBy: SortingParameter
 }
 
 enum SortingParameter: String {
     case period_of_report_date
     case filing_date
 }
 
 enum Order: String {
     case asc
     case desc
 }
 
 enum TimeFrame: String {
     case annual
     case quarterly
 }
 */

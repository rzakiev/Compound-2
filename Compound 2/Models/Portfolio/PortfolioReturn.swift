//
//  PortfolioReturn.swift
//  PortfolioReturn
//
//  Created by Robert Zakiev on 25.07.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation

struct PortfolioReturns: Codable {
    let values: [PortfolioReturn]
    
    func grossReturn() -> Double? {
        guard let startingValue = values.last?.accountValueAtStartOfYear,
              let endValue = values.first?.accountValueAtStartOfYear else {
                  Logger.log(error: "No initial or end value in the portfolio returns: \(values)")
                  return nil
              }
        
        return (endValue / startingValue - 1) * 100
    }
    
    func annualizedReturn() -> Double? {
        guard let startingValue = values.last?.accountValueAtStartOfYear,
              let endValue = values.first?.accountValueAtStartOfYear else {
                  Logger.log(error: "No initial or end value in the portfolio returns: \(values)")
                  return nil
              }
        return Statistics.cagrFor(firstFigure: startingValue, lastFigure: endValue, numberOfYearsInBetween: values.count - 1)
    }
}


extension PortfolioReturns {
    
    struct PortfolioReturn: CustomStringConvertible, Codable {
        
        let year: Int
        
        let accountValueAtStartOfYear: Double
        
        let deposits: [PortfolioDeposit]
        
        var description: String {
            "Year: \(year), account value at the start of the year: \(accountValueAtStartOfYear), deposits: \(deposits)"
        }
        
        ///Returns only those deposits that represent reinvested dividends
        func dividendDeposits() -> [PortfolioDeposit] {
            deposits.filter({ $0.type == .dividendReinvestment })
        }
        
        ///Returns only those deposits that represent the investor's own contributions
        func ownDeposits() -> [PortfolioDeposit] {
            deposits.filter({ $0.type == .ownDeposit })
        }
        
        ///Returns that year's portfolio return in percentage
        func yearReturn(accountValueAtEndOfYear: Double) -> Double {
            
            let accountValueAdjustedForMyDeposits = accountValueAtEndOfYear - ownDeposits().map({ $0.amount }).reduce(0, +)
            
            return (accountValueAdjustedForMyDeposits / accountValueAtStartOfYear - 1) * 100
        }
    }
    
    struct PortfolioDeposit: Codable {
        
        enum DepositType: String, Codable {
            //Situtation where we're reinvesting dividends from our holdings
            case dividendReinvestment = "dividendReinvestment"
            //Situtation where where we're depositing our own funds
            case ownDeposit = "ownDeposit"
        }
        
        let date: String
        let amount: Double
        let currency: Currency
        let type: DepositType
    }
}

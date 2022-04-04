//
//  PortfolioReturn.swift
//  PortfolioReturn
//
//  Created by Robert Zakiev on 25.07.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation

struct PortfolioReturns: Codable {
    
    let broker: String
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
        return PortfolioReturns.cagrFor(firstFigure: startingValue, lastFigure: endValue, numberOfYearsInBetween: values.count - 1)
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
            deposits.filter({ deposit in
                if case DepositType.dividendReinvestment = deposit.type {
                    return true
                }
                
                return false
            })
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
    
    ///Calculates the CAGR using the starting sum, the resultant sum, and the number of years it took for growth to occur
    static func cagrFor(firstFigure: Double, lastFigure: Double, numberOfYearsInBetween: Int) -> Double {
        return pow(lastFigure / firstFigure, 1 / Double((numberOfYearsInBetween - 1))) - 1
    }
    
    struct PortfolioDeposit: Codable {
        
        let date: String
        let amount: Double
        let currency: Currency
        let type: DepositType
        let ticker: String? //for DepositType.dividendReinvestment
    }
    
    enum DepositType: String, Codable, Equatable {
        //Case where we're reinvesting dividends from our holdings
        case dividendReinvestment = "dividendReinvestment"
        //Case where where we're depositing our own funds
        case ownDeposit = "ownDeposit"
    }
}

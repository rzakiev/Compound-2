//
//  DividendYield.swift
//  Compound 2
//
//  Created by Robert Zakiev on 02.02.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct DividendYieldCalculator {
    
    @available (*, unavailable)
    init() {  }
    
    public static func getDividendYieldsForCompanies(with quotes: [Quote]) -> [DividendYield] {
        
        var dividendYields = [DividendYield]()
        
        for quote in quotes {
            
            guard let ordinaryQuote = quote.ordinaryShareQuote else { continue }
            
            guard let companyData = try? FinancialDataManager.getCompanyData(for: quote.companyName) else {
                Logger.log(error: "DividendYieldCalculator: Unable to calculate the dividends for company \(quote.companyName)")
                continue
            }
            
            guard let dividend = companyData.dividends, dividend.last!.value > 0 else { continue }
            
            guard let sharesCount = try? FinancialDataManager.numberOfSharesFor(company: quote.companyName) else { continue }
            
            let preferredSharesCapitalization: Double = (quote.preferredShareQuote ?? 0.0) * Double(sharesCount.numberOfPreferredShares ?? 0)
            
            let marketCapitalization: Double = ordinaryQuote * Double(sharesCount.numberOfOrdinaryShares) + preferredSharesCapitalization
            
            guard marketCapitalization > 0 else {
                Logger.log(error: "Market cap for \(quote.companyName) is invalid: \(marketCapitalization)")
                continue
            }
            
            let yield = dividend.last!.value * 0.87 * 1_000_000_000 * 100 / marketCapitalization 
            
            dividendYields.append(.init(name: quote.companyName, yield: yield, isFixed: false))
        }
        
        return dividendYields
    }
}

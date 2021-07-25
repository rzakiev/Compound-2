//
//  DividendCalculator.swift
//  Compound 2
//
//  Created by Robert Zakiev on 21.03.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct DividendCalculator {
    
    @available (*, unavailable)
    init() {  }
    
    ///Returns the fixed dividend paid annually by the specified company multiplied by the number of shares in the position (provided if they have a fixed dividend policy)
    static func fixedDividend(for ticker: String, numberOfShares: Int, adjustForDividendTax: Bool = true) -> Double? {
        
        guard numberOfShares > 0 else {
            Logger.log(warning: "Calculating dividend flow for position with 0 shares")
            return 0
        }
        
        guard let dividendPerShare = fixedDividendPerShare(for: ticker, adjustForDividendTax: adjustForDividendTax) else {
            Logger.log(warning: "No fixed dividend for \(ticker)")
            return nil
        }
            
        let projectedDividend = Double(numberOfShares) * dividendPerShare
        
        return projectedDividend
    }
    
    ///Returns the fixed dividend per share paid annually by the specified company (provided if they have a fixed dividend policy)
    static func fixedDividendPerShare(for ticker: String, adjustForDividendTax: Bool = true) -> Double? {
        
        guard let dividendPerShare = constantDividendPerShare[ticker] else { return nil }
            return dividendPerShare
    }
}

//MARK: - Dividend Policies
extension DividendCalculator {
    private static let constantDividendPerShare: [String: Double] = [
//        "AFKS" : 1.19,
        "RTKM" : 5.0,
        "RTKMP" : 5.0,
        "ENRU" : 0.085,
        "ETLN" : 12,
        "MTSS" : 28,
        "SBER" : 18.7,
        "SBERP" : 18.7,
        "SMLT" : 83.3327,
        "HYDR" : 0.0586,
        "BSPB": 4.56
    ]
}

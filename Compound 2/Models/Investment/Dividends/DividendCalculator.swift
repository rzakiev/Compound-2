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
    
    ///Returns the fixed dividend paid annually by the specified company (provided if they have a fixed dividend policy)
    static func fixedDividend(for ticker: String, numberOfShares: Int, adjustForDividendTax: Bool = true) -> Double? {
        
        guard let tickerSymbol = ConstantTickerSymbols.ticker(for: ticker) else { return nil }
        
        guard let dividendPerShare = dividendPerShare[tickerSymbol] ?? dividendPerShare[String(ticker.dropLast(2))] ?? nil else { return nil }
            
        var projectedDividend = Double(numberOfShares) * dividendPerShare
        
        if adjustForDividendTax && !CorporateConstants.isAHolding(ticker)  {
            projectedDividend *= 0.87 //Adjusting the dividend for the dividend tax of 13% if the company is not a holding
        }
        
        return projectedDividend
    }
    
    ///Returns the fixed dividend per share paid annually by the specified company (provided if they have a fixed dividend policy)
    static func fixedDividendPerShare(for ticker: String, adjustForDividendTax: Bool = true) -> Double? {
        guard let dividendPerShare = dividendPerShare[ticker] else { return nil }
        
        return !CorporateConstants.isAHolding(ticker) && adjustForDividendTax ? dividendPerShare * 0.87 : dividendPerShare
    }
}

extension DividendCalculator {
    ///Returns the ratio of the sum of dividends for the last five years to the current market capitalization for all companies
    static func dividendsAsPartOfCapitalization(quotes: [Quote]) -> [(company: String, percentage: Double)] {
        
        var dividendsAsPartOfMarketCap = [(company: String, percentage: Double)]()
        for quote in quotes {
            guard let dividends = FinancialDataManager.getDividends(for: quote.companyName)?.suffix(5) else { continue }
            guard let marketCap = MarketCapitalization.calculateMarketCapitalization(for: quote.companyName, quote: quote) else { continue }
            let percentage = dividends.map({$0.value}).reduce(0,+) * 1_000_000_000 * 100 / marketCap
            dividendsAsPartOfMarketCap.append((quote.companyName, percentage))
        }
        
        return dividendsAsPartOfMarketCap.sorted(by: { $0.percentage > $1.percentage })
    }
}

//MARK: - Dividend Policies
extension DividendCalculator {
    private static let dividendPerShare: [String: Double] = [
//        "AFKS" : 1.19,
        "RTKM" : 5.0,
        "RTKMP" : 5.0,
        "ENRU" : 0.085,
        "ETLN" : 12,
        "MTSS" : 28,
//        "SBER" : 18.7,
//        "SBERP" : 18.7
    ]
}

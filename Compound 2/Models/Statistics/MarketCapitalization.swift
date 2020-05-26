//
//  MarketCapitalization.swift
//  Compound 2
//
//  Created by Robert Zakiev on 11.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

public struct MarketCapitalization {
    
    @available (*, unavailable)
    fileprivate init() {  }
    
    static func calculateMarketCapitalization(for company: String, quote: Quote? = nil) -> Double? {
       
        guard let currentQuote = quote ?? QuoteService.shared.getQuote(for: company) else {
            return nil
        }
        
        if let shares = try? FinancialDataManager.numberOfSharesFor(company: company),
            
            let ordinaryQuote = currentQuote.ordinaryShareQuote {
            
            //if the company has both ordinary and preferred shares
            if let preferredShares = shares.numberOfPreferredShares, let preferredQuote = currentQuote.preferredShareQuote {
                return Double(shares.numberOfOrdinaryShares) * ordinaryQuote + Double(preferredShares) * preferredQuote
                //                    completion(marketCap) //returing the fetched market cap back to the closure
            } else { //If the company has only oridnary shares
                return Double(shares.numberOfOrdinaryShares) * ordinaryQuote //calculating the market capitalization
                //                    completion(marketCap) //returing the fetched market cap back to the closure
            }
        }
        
        //Return nil in case something went wrong
        return nil
    }
    
    ///Returns the capitalization of a company's ordinary shares. Synchronous call if quote is not provided.
    static func calculateOrdinaryShareCapitalization(for company: String, quote: Quote? = nil) -> Double? {
        
        guard let currentQuote: Quote = quote ?? QuoteService.shared.getQuote(for: company) else {
            return nil
        }
        
        guard let ordinaryQuote = currentQuote.ordinaryShareQuote else { Logger.log(error: "No ordinary quote for \(company)"); return nil }
        
        guard let shareCount = try? FinancialDataManager.numberOfSharesFor(company: company) else { return nil }
        
        let ordinarySharesCapitalization: Double = ordinaryQuote * Double(shareCount.numberOfOrdinaryShares)
        
        return ordinarySharesCapitalization
    }
    
    ///Returns the capitalization of a company's preferred shares. Synchronous call.
    static func calculatePreferredShareCapitalization(for company: String, quote: Quote? = nil) -> Double? {
        
        guard let currentQuote: Quote = quote ?? QuoteService.shared.getQuote(for: company) else {
            return nil
        }
        
        guard let ordinaryQuote = currentQuote.ordinaryShareQuote else { Logger.log(error: "No prefered quote for \(company)"); return nil }
        
        guard let shareCount = try? FinancialDataManager.numberOfSharesFor(company: company) else { return nil }
        
        let preferreSharesCapitalization: Double = ordinaryQuote * Double(shareCount.numberOfOrdinaryShares)
        
        return preferreSharesCapitalization
    }
}

////
////  MarketCapitalization.swift
////  Compound 2
////
////  Created by Robert Zakiev on 11.04.2020.
////  Copyright © 2020 Robert Zakiev. All rights reserved.
////
//
//import Foundation
//
//public struct MarketCapitalization {
//
//    @available (*, unavailable)
//    fileprivate init() { Logger.log(error: "Initializing an instance of MarketCapitalization struct")  }
//
//    //Get the market capitalization of a specific company
////    static func getMarketCapitalization(for ticker: String, currentQuote: SimpleQuote) -> Double? {
////
////        guard let shareCount = try? FinancialDataManager.numberOfSharesFor(ticker: ticker) else { return nil }
////
////        var marketCap: Double = 0
////
////        marketCap += calculateOrdinaryShareCapitalization(ordinaryShareCount: shareCount.numberOfOrdinaryShares, quote: currentQuote)
////
////        if shareCount.numberOfPreferredShares != nil {
////            marketCap += calculatePreferredShareCapitalization(preferredShareCount: shareCount.numberOfPreferredShares!, quote: currentQuote)
////        }
////
//////        if let shares = try? FinancialDataManager.numberOfSharesFor(company: company),
//////
//////            let ordinaryQuote = currentQuote.ordinaryShareQuote {
//////
//////            //if the company has both ordinary and preferred shares
//////            if let preferredShares = shares.numberOfPreferredShares, let preferredQuote = currentQuote.preferredShareQuote {
//////                return Double(shares.numberOfOrdinaryShares) * ordinaryQuote + Double(preferredShares) * preferredQuote
//////                //                    completion(marketCap) //returing the fetched market cap back to the closure
//////            } else { //If the company has only oridnary shares
//////                return Double(shares.numberOfOrdinaryShares) * ordinaryQuote //calculating the market capitalization
//////                //                    completion(marketCap) //returing the fetched market cap back to the closure
//////            }
//////        }
////
////        //Return nil in case something went wrong
////        return marketCap
////    }
//
//    ///Returns the capitalization of a company's ordinary shares. Synchronous call if quote is not provided.
//    private static func calculateOrdinaryShareCapitalization(ordinaryShareCount: Int, quote: SimpleQuote) -> Double {
//
//        let ordinarySharesCapitalization: Double = quote.quote * Double(ordinaryShareCount)
//
//        return ordinarySharesCapitalization
//    }
//
//    ///Returns the capitalization of a company's preferred shares. Synchronous call.
//    private static func calculatePreferredShareCapitalization(preferredShareCount: Int, quote: SimpleQuote) -> Double {
//
//        let preferreSharesCapitalization: Double = quote.quote * Double(preferredShareCount)
//
//        return preferreSharesCapitalization
//    }
//}

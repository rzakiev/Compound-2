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
    fileprivate init() { Logger.log(error: "Initializing an instance of MarketCapitalization struct")  }

    static func getMarketCapitalization(for ticker: String, currentQuote: SimpleQuote) -> Double? {

        guard let ordinaryShareCount = ShareCountData.numberOfOrdinaryShares(for: ticker) else {
            return nil
        }

        var marketCap: Double = 0

        marketCap += calculateOrdinaryShareCapitalization(ordinaryShareCount: ordinaryShareCount, quote: currentQuote)
        
        if let preferredSharedCount = ShareCountData.numberOfPreferredShares(for: ticker)  {
            marketCap += calculatePreferredShareCapitalization(preferredShareCount: preferredSharedCount,
                                                               quote: currentQuote)
        }

        return marketCap
    }

    ///Returns the capitalization of a company's ordinary shares. Synchronous call if quote is not provided.
    private static func calculateOrdinaryShareCapitalization(ordinaryShareCount: Int, quote: SimpleQuote) -> Double {

        let ordinarySharesCapitalization: Double = quote.quote * Double(ordinaryShareCount)

        return ordinarySharesCapitalization
    }

    ///Returns the capitalization of a company's preferred shares. Synchronous call.
    private static func calculatePreferredShareCapitalization(preferredShareCount: Int, quote: SimpleQuote) -> Double {

        let preferreSharesCapitalization: Double = quote.quote * Double(preferredShareCount)

        return preferreSharesCapitalization
    }
}


struct ShareCountData {
    private static let ordinaryShareCount: [String: Int] = [
        "GEMC": 90_000_000,
        "ETLN": 383_445_455,
        "MDMG": 75_125_010,
        "CIAN": 69_040_000,
        "FIVE": 271_572_872,
        "FIXP": 850_000_000,
        "GLTR": 178_740_916,
        "HHRU": 50_635_720,
        "LNTA": 487_929_660,
        "MAIL": 226_121_327,
        "OKEY": 269_068_982,
        "OZON": 208_202_000,
        "SFTL": 200_000_000,
        "TCSG": 199_310_000,
    ]
    
    private static let preferredShareCount: [String: Int] = [
        ://"SBERP": 1_000_000_000
    ]
    
    static func numberOfOrdinaryShares(for ticker: String) -> Int? {
        ordinaryShareCount[ticker]
    }
    
    static func numberOfPreferredShares(for ticker: String) -> Int? {
        preferredShareCount[ticker]
    }
    
    static func hasPreferredShares(ticker: String) -> Bool {
        preferredShareCount[preferredShareTicker(for: ticker)] != nil
    }
    
    static func preferredShareTicker(for ticker: String) -> String {
        return ticker + "P"
    }
    
    static func depositoryReceiptsWithShareCount() -> [String] {
        return ordinaryShareCount.map(\.key)
    }
}

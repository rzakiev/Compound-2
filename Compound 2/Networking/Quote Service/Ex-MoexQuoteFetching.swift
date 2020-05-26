//
//  Ex-MoexQuoteFetching.swift
//  Compound 2
//
//  Created by Robert Zakiev on 02.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

extension QuoteService {
    private static let moexBaseURL = "https://iss.moex.com/iss/engines/stock/markets/shares/boards/TQBR/securities/"
    private static let endOfURL = ".json?iss.meta=off&iss.only=marketdata&marketdata.columns=LAST"
    
    private static let allQuotesSourceURL = "https://iss.moex.com/iss/engines/stock/markets/shares/boards/tqbr/securities.json?iss.meta=on&iss.only=marketdata&marketdata.columns=SECID,LAST"
    
    ///Returns the URL of the XML containing the quote for the specified company
    private func moexQuoteURL(for ticker: String) -> String {
        return QuoteService.moexBaseURL + ticker + QuoteService.endOfURL
    }
}


///Methods for fetching quotes from the Moscow Exchange via their API
extension QuoteService {
    ///Synchronous request
    func getMoexQuote(for ticker: String) -> Double? {
        
        let quoteSourceURL = QuoteService.shared.moexQuoteURL(for: ticker)
        
        guard let url = URL(string: quoteSourceURL) else {
            Logger.log(error: "Unable to create a URL struct using the string: \(quoteSourceURL)")
            return nil
        }
        
        guard let jsonData = try? Data(contentsOf: url) else {
            Logger.log(error: "Unable to instantiate an instance of type Data from the URL: \(url)")
            return nil
        }
        
        return MoexDataParser.parseMoexJSON(jsonData)
    }
    ///Synchronous request
    func getAllMoexQuotes() -> [SimpleQuote] {
        guard let url = URL(string: QuoteService.allQuotesSourceURL) else {
            Logger.log(error: "Unable to create a URL using the string: \(QuoteService.allQuotesSourceURL)")
            return []
        }
//        print(url)
        
        guard let jsonData = try? Data(contentsOf: url) else {
            Logger.log(error: "Unable to create a Data instance using the URL: \(QuoteService.allQuotesSourceURL)")
            return []
        }
//        print(jsonData)
        
        return MoexDataParser.parseMoexJSON(jsonData)//.sorted(by: { $0.quote > $1.quote })
    }
}

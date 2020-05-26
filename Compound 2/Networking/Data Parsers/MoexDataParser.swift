//
//  MoexDataParser.swift
//  Compound 2
//
//  Created by Robert Zakiev on 02.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct MoexDataParser {
    
    @available(*, unavailable)
    fileprivate init() {}
    
    ///Parses the quote from the plist file retrieved via the Moscow Exchange API
    static func parseMoexJSON(_ json: Data) -> Double? {
        
        guard let quote = try? JSONDecoder().decode(MoexQuote.self, from: json) else {
            Logger.log(error: "Unable to decode the quote")
            return nil
        }
        
        return quote.marketdata.data[safe: 0]?.last ?? nil
    }
    
    ///Parses all quotes from the plist file retrieved via the Moscow Exchange API
    static func parseMoexJSON(_ json: Data) -> [SimpleQuote] {
        
        guard let quotes = try? JSONDecoder().decode(MoexQuotes.self, from: json) else {
            Logger.log(error: "Unable to decode the quotes")
            return []
        }
        
        var simpleQuotes = [SimpleQuote]()
        for quote in quotes.marketdata.data {
            
            var name: String
            if case .string(let jsonName) = quote[safe: 0] { name = jsonName }
            else { continue }
            
            var price: Double
            if case .double(let jsonPrice) = quote[safe: 1] { price = jsonPrice }
            else { continue }
            
            simpleQuotes.append(.init(ticker: name, quote: price))
        }
        
        return simpleQuotes
    }
}



extension MoexDataParser {
    static func parseDividendJSON(_ json: Data) -> Dividends? {
        guard let parsedDividends = try? JSONDecoder().decode(Dividends.self, from: json) else {
            Logger.log(error: "unable to decode dividends")
            return nil
        }
        
        if parsedDividends.count == 0 { Logger.log(warning: "No dividends") }
        
        return parsedDividends
    }
}

// MARK: - Dividend
struct Dividend: Codable {
    let charsetinfo: Charsetinfo?
    let dividends: [DividendElement]?
}

// MARK: - Charsetinfo
struct Charsetinfo: Codable {
    let name: String
}

// MARK: - DividendElement
struct DividendElement: Codable {
    let secid, isin, registryclosedate: String
    let value: Double
    let currencyid: String
}

typealias Dividends = [Dividend]


//RZ Structs
//struct CompanyDividend {
//    let ticker: String
//    let payouts: [Dividend]
//}
//
//struct Dividend {
//    let payoutDate: Date
//    let amount: Double
//    let currency: Currency
//}

//struct AnnualDividend {
//    let payouts: [Dividend]
//}

enum Currency {
    case Rouble
    case USD
}

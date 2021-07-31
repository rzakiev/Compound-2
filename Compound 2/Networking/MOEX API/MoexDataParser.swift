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
    
    ///Parses the quote for some company from the plist file retrieved via the Moscow Exchange API
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
            
            var marketCap: Double?
            if case .double(let jsonMarketCap) = quote[safe: 2] { marketCap = jsonMarketCap }
            else { marketCap = nil }
            
            simpleQuotes.append(.init(ticker: name, quote: price, marketCap: marketCap))
        }
        
        return simpleQuotes
    }
}

extension MoexDataParser {
    static func parseDividendJSON(_ json: Data) -> MoexDividends? {
        guard let parsedDividends = try? JSONDecoder().decode(MoexDividends.self, from: json) else {
            Logger.log(error: "unable to decode dividends")
            return nil
        }
        
        if parsedDividends.count == 0 { Logger.log(warning: "No dividends") }
        
        return parsedDividends
    }
}

// MARK: - Dividend
struct MoexDividend: Codable {
    let charsetinfo: Charsetinfo?
    let dividends: [DividendElement]?
}

// MARK: - Charsetinfo
struct Charsetinfo: Codable {
    let name: String
}

// MARK: - DividendElement
struct DividendElement: Codable {
    
    let secid, isin, registryclosedate: String //secid is the ticker symbol
    let value: Double
    let currencyid: String
}

typealias MoexDividends = [MoexDividend]

extension MoexDataParser {
    // MARK: - MoexQuote for parsing a single quote
    struct MoexQuote: Codable {
        let marketdata: QuoteData
    }
}

enum Currency: String, Codable {
    
    case Rouble = "RUB"
    case USD = "USD"
    case undefined = "undefined"
    
    init(fromString string: String) {
        if string == "USD" {
            self = .USD
        } else if string == "RUB" {
            self = .Rouble
        } else {
            self = .undefined
        }
    }
    
    var sign: String {
        switch self {
        case .Rouble: return "₽"
        case .USD: return "$"
        default:
            return ""
        }
    }
}

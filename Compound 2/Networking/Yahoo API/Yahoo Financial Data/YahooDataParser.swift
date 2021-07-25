//
//  YahooDataParser.swift
//  Compound 2
//
//  Created by Robert Zakiev on 24.04.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation


//MARK: - Quote Parser
struct YahooDataParser {
    
    ///Ancillary struct that mimics the response of the Yahoo Quote API
    struct YahooQuote: Codable {
        
        struct QuoteSummary: Codable {
            let result: [Result]
        }
        
        struct Result: Codable {
            let price: Price
        }
        
        struct Price: Codable {
            let regularMarketPrice: PostMarketChange
        }
        
        struct PostMarketChange: Codable {
            let raw: Double
            let fmt: String
        }
        
        let quoteSummary: QuoteSummary
    }

    
    static func parseYahooQuoteJSON(_ json: Data, for ticker: String) -> Double? {
        guard let quote = try? JSONDecoder().decode(YahooQuote.self, from: json) else {
            Logger.log(error: "Unable to decode the yahoo quote for \(ticker)")
            return nil
        }
        return quote.quoteSummary.result[0].price.regularMarketPrice.raw
    }
}



//MARK: - Yahoo Financial Data Parser

extension YahooDataParser {
    
    
    
    ///Ancillary struct that mimics the Yahoo API response. Used for easy decoding.
    struct YahooFinancialData: Codable {
        let chart: YahooResponseData
        
        struct YahooResponseData: Codable {
            let result: [YahooResponseDataResult]
            
            struct YahooResponseDataResult: Codable {
                let meta: YahooFinancialDataMeta
                let timestamp: [Int]
                let events: YahooResponseEvents
                
                struct YahooFinancialDataMeta: Codable {
                    let currency: String
                }
                
                struct YahooResponseEvents: Codable {
                    let dividends: [String: YahooDividend]
                    
                    struct YahooDividend: Codable {
                        let amount: Double
                        let date: Int //It's a UNIX timestamp
                    }
                }
                
                let indicators: YahooResponseIndicators
                
                struct YahooResponseIndicators: Codable {
                    let quote: [YahooResponseQuotes]
                    
                    struct YahooResponseQuotes: Codable {
                        let close: [Double]
                    }
                }
            }
        }
    }
    
    ///Decodes the financial data from Yahoo API into an instance of YahooFinancialData
    static func parseYahooQuoteAndDividendHistoryJSON(_ json: Data) -> QuoteAndDividendHistory? {
        guard let decodedJSON = try? JSONDecoder().decode(YahooFinancialData.self, from: json) else {
            Logger.log(error: "Unable to decode the Data into an instance of YahooFinancialData")
            return nil
        }
        
        guard let dividends = decodedJSON.chart.result.first?.events.dividends.map(\.value),
              let quoteTimestamps = decodedJSON.chart.result.first?.timestamp,
              let quotes = decodedJSON.chart.result.first?.indicators.quote.first.map(\.close) else {
            Logger.log(error: "The dividends and quotes cannot be parsed")
            return nil
        }
        
        var historicalQuotes: [HistoricalQuote] = []
        if quotes.count == quoteTimestamps.count {
            for i in 0..<quotes.count {
                historicalQuotes.append(.init(quote: quotes[i], date: Double(quoteTimestamps[i])))
            }
        } else {
            Logger.log(error: "YahooDataParser: Mismatch between the number of quotes: \(quotes.count) and quote timestamps: \(quoteTimestamps.count)")
        }
        
        let currency = Currency(fromString: decodedJSON.chart.result.first?.meta.currency ?? "undefined")
        
        let mappedDividends = dividends.map({ Dividend(payment: $0.amount, currency: currency, date: Double($0.date)) })
        
        return .init(dividends: mappedDividends, historicalQuotes: historicalQuotes)
    }
}

struct QuoteAndDividendHistory: Codable {
    let dividends: [Dividend]
    let historicalQuotes: [HistoricalQuote]
}

///Quote that also contains a corresponding date
struct HistoricalQuote: Codable {
    let quote: Double
    let date: Double //UNIX timestamp
}

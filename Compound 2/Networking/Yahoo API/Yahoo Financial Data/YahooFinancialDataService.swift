//
//  YahooFinancialDataService.swift
//  Compound 2
//
//  Created by Robert Zakiev on 06.05.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation

///Fetches the financial data from the Yahoo Data Service
struct YahooFinancialDataService {
    
    @available(*, unavailable)
    fileprivate init() { Logger.log(error: "Initializing an instance of \(Self.self)") }
}

//MARK: - Constants
extension YahooFinancialDataService {
    fileprivate static let baseURL = "https://query1.finance.yahoo.com/v8/finance/chart/"
    
    private static let yahooQuoteDirectory = "QuoteHistory/"
    private static let yahooDividendDirectory = "DividendHistory/"
    
    ///Generates a URL to a Yahoo API endpoint that returns quote history and a list of dividends
    ///
    ///- Parameter ticker: The ticker of the company whose data is to be retrieved from the resultant URL
    ///- Parameter period1: The start of the date range. The value must be provided as a timestamp.
    ///- Parameter period2: The end of the date range. The value must be provided as a timestamp.
    ///- Parameter interval: The time interval between the retrieved values.
    private static func quoteAndDividendURL(for ticker: String, period1: Double, period2: Double, interval: YahooFinancialDataInvterval = .oneMonth) -> String {
        //Example: https://query1.finance.yahoo.com/v8/finance/chart/MSFT?symbol=MSFT&period1=1559457037&period2=1591079437&interval=1mo&events=div%7Csplit
        return baseURL + ticker + "?symbol=" + ticker + "&period1=" + String(Int(period1)) + "&period2=" + String(Int(period2)) + "&interval=" + interval.rawValue + "&events=div%7Csplit"
    }
}

//MARK: - Fetching the data
extension YahooFinancialDataService {
    ///Fetches quote history and a list of dividends from Yahoo API and then stores it in the local storage
    ///
    ///- Parameter ticker: The ticker of the company whose data is to be retrieved from Yahoo API
    ///- Parameter startDate: The start of the date range. The value must be provided as a string in the following format: `MM/dd/yyyy`
    ///- Parameter endDate: The end of the date range. The value must be provided  as a string in the following format: `MM/dd/yyyy`
    ///- Parameter interval: The time interval between the retrieved values.
    static func fetchQuoteAndDividendHistorySync(for ticker: String, startDate: String, endDate: String, interval: YahooFinancialDataInvterval = .oneMonth) -> QuoteAndDividendHistory? {
        
        guard let period1 = Date.convertToTimestamps(startDate), let period2 = Date.convertToTimestamps(endDate) else {
            Logger.log(error: "Unable to convert the provided dates into timestamps: start date — \(startDate), end date - \(endDate)")
            return nil
        }
        
        let urlString = quoteAndDividendURL(for: ticker, period1: period1, period2: period2, interval: interval)
        
        guard let url = URL(string: urlString) else {
            Logger.log(error: "Unable to instantiate a URL from the following string: \(urlString)")
            return nil
        }
        
        guard let jsonData = try? Data(contentsOf: url) else {
            Logger.log(error: "Unable to instantiate an instance of type Data from the URL: \(url)")
            return nil
        }
        
        guard let quoteAndDividendHistory = YahooDataParser.parseYahooQuoteAndDividendHistoryJSON(jsonData) else { return nil }
        
        guard let encodedDividends = try? JSONEncoder().encode(quoteAndDividendHistory.dividends) else { return nil }
        FileManager.saveFileToApplicationSupport(in: yahooDividendDirectory, name: distillTicker(ticker), content: encodedDividends)
        
        guard let encodedQuoteHistory = try? JSONEncoder().encode(quoteAndDividendHistory.historicalQuotes) else { return nil }
        FileManager.saveFileToApplicationSupport(in: yahooQuoteDirectory, name: distillTicker(ticker), content: encodedQuoteHistory)
        
        return quoteAndDividendHistory
    }
    
    
    static func fetchQuoteAndDividendHistoryAsync(for ticker: String, startDate: String, endDate: String, interval: YahooFinancialDataInvterval = .oneMonth, completion: @escaping (QuoteAndDividendHistory?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let dividendAndQuoteHistory = fetchQuoteAndDividendHistorySync(for: ticker, startDate: startDate, endDate: endDate, interval: interval)
            completion(dividendAndQuoteHistory)
        }
    }
    
    ///Fetches financial data via Yahoo API asynchronously for all companies in the ideas list
    static func fetchQuoteAndDividendHistoryForAllCompaniesAsync() {
        let tickers = YahooQuoteService.getTickerList()
        
        tickers.forEach({ ticker in
            fetchQuoteAndDividendHistoryAsync(for: ticker, startDate: "04/01/2010", endDate: "05/05/2021", interval: .oneMonth, completion: { _ in })
        })
        
        //`.ME` is added because Yahoo Finance does not otherwise recognize the Russian tickers
        C.Tickers.allTickerSymbolsWithNames().map({ $0.ticker + ".ME" }).forEach({ticker in
            fetchQuoteAndDividendHistoryAsync(for: ticker, startDate: "04/01/2010", endDate: "05/05/2021", interval: .oneMonth, completion: {_ in})
        })
    }
}

extension YahooFinancialDataService {
    ///Removes `.ME` from tickers. For example, `AFKS.ME` will turn into `AFKS`
    static func distillTicker(_ ticker: String) -> String {
        if ticker.suffix(3) == ".ME" { return String(ticker.dropLast(3)) }
        else { return ticker }
    }
}

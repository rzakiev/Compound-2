//
//  YahooQuoteService.swift
//  Compound 2
//
//  Created by Robert Zakiev on 24.04.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation

final class YahooQuoteService: ObservableObject {
    
    public static let shared = YahooQuoteService()
    
    @Published final private(set) var allQuotes = [SimpleQuote]()
    
    fileprivate init() {
        Logger.log(operation: "QS: Initializing the shared instance of \(Self.self)")
        YahooQuoteService.updateQuotes(every: .minute)
    }
}



extension YahooQuoteService {
    func getQuote(for ticker: String) -> SimpleQuote? {
        guard let ordinaryQuote = getYahooQuote(for: ticker) else { return nil }
        
        let receivedQuote = SimpleQuote(ticker: ticker, quote: ordinaryQuote, marketCap: nil)
        
        self.allQuotes.append(receivedQuote)
        
        return receivedQuote
    }
    
    func getQuoteAsync(for ticker: String, completion: ((SimpleQuote?) -> Void)?, queue: DispatchQueue) {
        queue.async { [weak self] in
            guard let self = self  else { return }
            let quote = self.getQuote(for: ticker)
            completion?(quote)
        }
    }
    
    func getAllQuotesAsync(completion: (([SimpleQuote]) -> Void)? = nil, queue: DispatchQueue = .global(qos: .background)) {
        
        let tickers = YahooQuoteService.getTickerList()
        
        let threadCount = tickers.count / 10
        
        for i in 0..<threadCount {
            let _ = Timer.scheduledTimer(withTimeInterval: 4, repeats: false) {_ in
                queue.async {
                    if i != threadCount - 1 {
                        var quotes: [SimpleQuote] = []
                        for ticker in tickers[(i * 10)...(i * 10 + 9)] {
                            guard let quote = self.getYahooQuote(for: ticker) else { continue }
                            print(quote)
                            quotes.append(.init(ticker: ticker, quote: quote, marketCap: nil))
                        }
                        self.allQuotes.append(contentsOf: quotes)
                        completion?(quotes)
                    } else {
                        var quotes: [SimpleQuote] = []
                        for ticker in tickers[(i * 10)...(tickers.count - 1)] {
                            guard let quote = self.getYahooQuote(for: ticker) else { continue }
                            print(quote)
                            quotes.append(.init(ticker: ticker, quote: quote, marketCap: nil))
                        }
                        self.allQuotes.append(contentsOf: quotes)
                        completion?(quotes)
                    }
                }
            }
        }
    }
    
    func quote(for ticker: String) -> SimpleQuote? {
        return allQuotes.first(where: { $0.ticker == ticker })
    }
}


extension YahooQuoteService {
    ///Updates the quotes every specified time period
    static func updateQuotes(every timePeriod: TimeUnit) {
        
        guard Date.todayIsNotWeekend else { return } //No need to update the quotes on the weekend
        
        let interval: Double
        switch timePeriod {
        case .second: interval = 1
        case .minute: interval = 60
        case .hour: interval = 3600
        case .day: interval = 216000
        default: interval = 60
        }
        
        
        let _ = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (timer) in
            Logger.log(operation: "Updating Yahoo quotes at \(Date())")
            
            YahooQuoteService.shared.getAllQuotesAsync(completion: { _ in })
        }
    }
}

extension YahooQuoteService {
    private static let yahooBaseURL = "https://query1.finance.yahoo.com/v10/finance/quoteSummary/"
    private static let yahooEndOfURL = "?modules=price"
    
    ///Returns the URL of the JSON containing the quote for the specified company
    private static func yahooQuoteURL(for ticker: String) -> String {
        return YahooQuoteService.yahooBaseURL + ticker + YahooQuoteService.yahooEndOfURL
    }
    
    ///Synchronous request
    func getYahooQuote(for ticker: String) -> Double? {
        
        let quoteSourceURL = YahooQuoteService.yahooQuoteURL(for: ticker)
        
        guard let url = URL(string: quoteSourceURL) else {
            Logger.log(error: "Unable to create a URL struct using the string: \(quoteSourceURL), ticker: \(ticker)")
            return nil
        }
        
        guard let jsonData = try? Data(contentsOf: url) else {
            Logger.log(error: "Unable to instantiate an instance of type Data from the URL: \(url), ticker: \(ticker)")
            return nil
        }
        
        return YahooDataParser.parseYahooQuoteJSON(jsonData, for: ticker)
    }
    ///Asynchronous request
    func getYahooQuoteAsync(for ticker: String, completion: (SimpleQuote?) -> Void, qos: DispatchQueue = .global(qos: .background)) {
        guard let quote = getYahooQuote(for: ticker) else {
            Logger.log(error: "No yahoo quote for \(ticker))")
            completion(nil)
            return
        }
        
        completion(.init(ticker: ticker, quote: quote, marketCap: nil))
    }
    
}

extension YahooQuoteService {
    static func getTickerList() -> [String] {
        
        guard let files = try? FileManager.default.contentsOfDirectory(atPath: Bundle.main.resourcePath! + C.UpsidesVariables.upsidesDirectory) else {
            Logger.log(error: "Unable to enumerate files in the following directory: \(C.UpsidesVariables.upsidesDirectory)")
            return []
        }
        
        var allIdeas = InvestmentIdeas(author: "", values: [])
        
        for fileName in files {
            
            let splitName = fileName.split(separator: ".")
            let name = String(splitName[0])
            let format = String(splitName[1])
            
            guard let jsonPath = Bundle.main.path(forResource: name, ofType: format, inDirectory: C.UpsidesVariables.upsidesDirectory) else {
                Logger.log(error: "No path for \(name).\(format)")
                continue
            }
            
            guard let localIdeasData = FileManager.default.contents(atPath: jsonPath) else {
                Logger.log(error: "No ideas upsides file")
                continue
            }
            
            guard let decodedIdeas = try? JSONDecoder().decode(InvestmentIdeas.self, from: localIdeasData) else {
                Logger.log(error: "Unable to decode the malishok's investment ideas file")
                return []
            }
            
            allIdeas.values += decodedIdeas.values
        }
        
        let foreignStocks = allIdeas.values.filter({ $0.currency != .Rouble })
        
        return foreignStocks.map(\.ticker)
    }
}

extension YahooQuoteService {
    static func printAllQuotes() {
        YahooQuoteService.shared.allQuotes.forEach { quote in
            print(quote)
        }
    }
}

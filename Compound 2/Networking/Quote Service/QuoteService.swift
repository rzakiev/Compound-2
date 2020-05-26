//
//  QuoteService.swift
//  Compound 2
//
//  Created by Robert Zakiev on 05/09/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

final class QuoteService: ObservableObject {
    
    public static let shared = QuoteService()
    
    @Published final private(set) var allQuotes = [SimpleQuote]()
    
//    @Published final private(set) var moexQuotes = [SimpleQuote]()
    
    fileprivate init() {
        Logger.log(operation: "QS: Initializing the shared instance of the Quote Service")
        
        if Date.todayIsWeekend() == false {
            QuoteService.updateQuotes(every: .minute)
        }
    }
    
    ///Synchronously fetch a quote for a specific company by providing its ticker symbol
    public func getQuote(for ticker: String) -> Quote? {
        
        let ordinaryQuote = getMoexQuote(for: ticker)
        
        return Quote(companyName: ticker, ordinaryShareQuote: ordinaryQuote, preferredShareQuote: nil)
    }
    
    ///Synchronously fetch a quote for a specific company by providing its company name
    public func getQuoteFor(companyName company: String) -> Quote? {
        guard let ticker = ConstantTickerSymbols.ticker(for: company) else {
            Logger.log(error: "No ticker symbol for \(company)")
            return nil
        }
        
        let ordinaryQuote = getMoexQuote(for: ticker)
        var preferredQuote: Double? = nil
        
        if ConstantTickerSymbols.companiesWithPreferredShares.contains(company) {
            preferredQuote = getMoexQuote(for: ConstantTickerSymbols.preferredShareTicker(for: ticker))
        }
        
        return Quote(companyName: company, ordinaryShareQuote: ordinaryQuote, preferredShareQuote: preferredQuote)
    }
    
    ///Asynchronously fetch a quote for a specific company
    public func getQuoteAsync(for ticker: String, completion: ((Quote?) -> Void)? = nil) {
        
        DispatchQueue.main.async { [unowned self] in
            let quote = self.getQuote(for: ticker)
            completion?(quote)
        }
    }
    
    public func getQuoteAsyncFor(companyName name: String, completion: ((Quote?) -> Void)? = nil) {
        
        DispatchQueue.main.async { [unowned self] in
            let quote = self.getQuoteFor(companyName: name)
            completion?(quote)
        }
    }
    
    public func getAllQuotesAsync(completion: (([SimpleQuote]) -> Void)? = nil) {
        
        DispatchQueue.main.async { [unowned self] in
            let newQuotes = self.getAllMoexQuotes()
            self.allQuotes = newQuotes
            completion?(newQuotes)
        }
    }
    
    ///Asynchronously fetch a quote for all public companies
//    public func getQuotesForAllCompaniesAsync(completion: (([Quote]) -> Void)?) {
//        guard let allPublicCompanies = try? FinancialDataManager.getSmartlabLinks().map({$0.key}) else {
//            Logger.log(warning: "QS: Unable to get the list of public companies")
//            completion?([]) //return an empty array of quotes if the list of public companies could not be fetched
//            return
//        }
//
//        //Asynchronously fetch the quotes and then pass them to the completion callback
//        DispatchQueue.global(qos: .default).async { [unowned self] in
//            Logger.log(operation: "QS: Fetching quotes for all companies")
//            var quotes = [Quote]()
//            for company in allPublicCompanies {
//                if let quote = self.getQuote(for: company) { //synchronous quote fetching
//                    quotes.append(quote)
//                }
//            }
//            DispatchQueue.main.async {
//                completion?(quotes)
//            }
//        }
//    }
//
//    public func getMoexQuotesAsync(completion: @escaping ([SimpleQuote]) -> Void) {
//        //Asynchronously fetch the quotes and then pass them to the completion callback
//        DispatchQueue.global(qos: .userInitiated).async {
//            let quotes = self.getAllMoexQuotes()
//            DispatchQueue.main.async {
//                completion(quotes)
//            }
//        }
//    }
    
    ///Asynchronously fetches all quotes and assigns them to the shared instance of the quote service
//    public func fetchAllQuotesAsync() {
//        getQuotesForAllCompaniesAsync(completion: { quotes in
//            QuoteService.shared.allQuotes = quotes
//        })
//    }
}

extension QuoteService {
    ///Returns a quote from the shared instance of the Quote Service (if it's there)
    public func quote(for ticker: String) -> Double? {
        return self.allQuotes.first(where: { $0.ticker == ticker })?.quote
    }
//    ///Returns the ordinary share price from the shared instance of the Quote Service (if it's there)
//    public func getOrdinaryQuote(for company: String) -> Double? {
//        return self.allQuotes.first(where: { $0.companyName == company })?.ordinaryShareQuote
//    }
//    ///Returns the preferred share price from the shared instance of the Quote Service (if it's there)
//    public func getPreferredQuote(for company: String) -> Double? {
//        return self.allQuotes.first(where: { $0.companyName == company })?.preferredShareQuote
//    }
}



//MARK: - Updating quotes
extension QuoteService {
    private static func updateQuotes(every timePeriod: TimePeriod) {
        
        let interval: Double
        switch timePeriod {
        case .second: interval = 1
        case .minute: interval = 60
        case .hour: interval = 3600
        case .day: interval = 216000
        }
        
        let _ = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { (timer) in
            Logger.log(operation: "Updating quotes at \(Date())")
            QuoteService.shared.getAllQuotesAsync()
        }
    }
}

//MARK: - Fake Quotes
extension QuoteService {
    ///STRICTLY FOR TESTS
//    static func generateFakeQuotes() {
//        
//        let _ = Timer.scheduledTimer(withTimeInterval: 4, repeats: true) { (timer) in
//            var fakeQuotes = [SimpleQuote]()
//            for ticker in ConstantTickerSymbols.allTickersWithNames() {
//                fakeQuotes.append(.init(ticker: ticker, quote: Double.random(in: 1...1000)))
//            }
//            shared.allQuotes = fakeQuotes
//        }
//    }
}


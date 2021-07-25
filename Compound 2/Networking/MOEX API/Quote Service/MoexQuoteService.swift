//
//  QuoteService.swift
//  Compound 2
//
//  Created by Robert Zakiev on 05/09/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

///SIngleton responsible for fetching MOEX quotes
final class MoexQuoteService: ObservableObject {
    
    public static let shared = MoexQuoteService()
    
    @Published final private(set) var allQuotes = [SimpleQuote]()
    
    fileprivate init() {
        Logger.log(operation: "QS: Initializing the shared instance of \(Self.self)")
        MoexQuoteService.updateQuotes(every: .minute)
    }
    
    ///Synchronously fetch a quote for a specific company by providing its ticker symbol
    func getQuote(for ticker: String) async throws -> SimpleQuote? {

        guard let ordinaryQuote = getMoexQuote(for: ticker) else { return nil }

        return SimpleQuote(ticker: ticker, quote: ordinaryQuote, marketCap: nil)
    }
    
//    ///Asynchronously fetch a quote for a specific company
//    func getQuoteAsync(for ticker: String, completion: ((SimpleQuote?) -> Void)? = nil) {
//
//        guard let self = self  else { return }
//        let quote = await self.getQuote(for: ticker)
//        completion?(quote)
//
//    }
    
    ///Asyncronously fetches all quotes from the MOEX API and then stores them in the shared instance of the Quote Service
    func getAllQuotes(completion: (([SimpleQuote]) -> Void)? = nil) async {
        
        let newQuotes = self.getAllMoexQuotes()
        guard newQuotes.count > 0 else {
            Logger.log(error: "MoexQuoteService: Fetched 0 quotes")
            return
        }
        
        self.allQuotes = newQuotes
        completion?(newQuotes)
    }
    
}

extension MoexQuoteService {
    ///Returns a locally stored quote from the shared instance of the Quote Service (if it's there)
    public func quote(for ticker: String) -> SimpleQuote? {
        return self.allQuotes.first(where: { $0.ticker == ticker })
    }
}

//MARK: - Updating quotes
extension MoexQuoteService {
    //Sets the frequency with which quotes will be updated. This method must be called only once in the initializer
    fileprivate static func updateQuotes(every timePeriod: TimePeriod) {
        
        guard Date.todayIsNotWeekend else { return } //No need to update the quotes on the weekend
        
        let interval: Double
        switch timePeriod {
        case .second: interval = 1
        case .minute: interval = 60
        case .hour: interval = 3600
        case .day: interval = 216000
        default: interval = 60
        }
        
        let timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(fetchAllQuotes), userInfo: nil, repeats: true)

    }
    
    @objc func fetchAllQuotes() async {
        Logger.log(operation: "Updating quotes at \(Date())")
        await MoexQuoteService.shared.getAllQuotes()
    }
}

//MARK: - Fake Quotes
extension MoexQuoteService {
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

//protocol QuoteService {
//    var allQuotes: [SimpleQuote] { get }
//
//    static func updateQuotes(every timePeriod: TimePeriod)
//
//    func getQuote(for ticker: String) -> SimpleQuote?
//
//    func getQuoteAsync(for ticker: String, completion: ((SimpleQuote?) -> Void)?, queue: DispatchQueue)
//
//    func getAllQuotesAsync(completion: (([SimpleQuote]) -> Void)?, queue: DispatchQueue)
//
//    ///Retrieves a quote from the singleton
//    func quote(for ticker: String) -> SimpleQuote?
//}

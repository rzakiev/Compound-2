//
//  DividendService.swift
//  Compound 2
//
//  Created by Robert Zakiev on 20.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct MoexDividendService {
    @available (*, unavailable)
    fileprivate init() { Logger.log(error: "Initializing an instance of \(Self.self)") }
}

//MARK: - Fetching dividends
extension MoexDividendService {
    private static let moexDividendBaseURL = "https://iss.moex.com/iss/securities/"
    private static let moexDividendURLEnd = "/dividends.json?iss.meta=off&iss.json=extended"
    
    private static func dividendSourceURL(forTicker ticker: String) -> String {
        return moexDividendBaseURL + ticker + moexDividendURLEnd
    }
    
    ///Returns the dividends paid out by the specifie company. Synchronous call.
    static func fetchDividends(forTicker ticker: String) -> MoexDividends? {
        
        let dividendSourceURL = MoexDividendService.dividendSourceURL(forTicker: ticker)
        
        guard let url = URL(string: dividendSourceURL) else {
            Logger.log(error: "Unable to create a URL struct using the string: \(dividendSourceURL)")
            return nil
        }
        
        guard let jsonData = try? Data(contentsOf: url) else {
            Logger.log(error: "Unable to instantiate an instance of type Data from the URL: \(url)")
            return nil
        }
        
        let dividends: MoexDividends? = MoexDataParser.parseDividendJSON(jsonData)
        
        return dividends
    }
    
    ///Returns the dividends paid out by the specified company. Asynchronous call.
    static func fetchDividendsAsync(forTicker ticker: String, completion: @escaping (MoexDividends?) -> Void, queue: DispatchQueue = .global(qos: .background)) {
        queue.async {
            let dividends = fetchDividends(forTicker: ticker)
            queue.async {
                completion(dividends)
            }
        }
    }
    
    ///Returns the dividends paid out by all companies. Asynchronous call.
    static func fetchDividendsForSomeCompaniesAsync(tickers: [String], completion: @escaping (CompanyDividends) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var dividends: [(ticker: String, dividends: MoexDividends)] = []
            for ticker in tickers {
                guard let dividend = fetchDividends(forTicker: ticker) else { Logger.log(error: "Couldn't fetch dividends for \(ticker)"); continue }
                dividends.append((ticker, dividend))
            }
            completion(dividends)
        }
    }
    
    ///Returns the dividends paid out by all companies. Synchronous call.
    static func fetchDividendsForSomeCompaniesSync(tickers: [String]) -> CompanyDividends {
        
            var dividends: CompanyDividends = []
        
            for ticker in tickers {
                guard let dividend = fetchDividends(forTicker: ticker) else { Logger.log(error: "Couldn't fetch dividends for \(ticker)"); continue }
                dividends.append((ticker, dividend))
            }
        
            return dividends
    }
}

extension MoexDividendService {
    ///Returns an array of annual dividends generated from the passed array of dividends
    static func groupDividendsByYear(_ dividends: [DividendElement]) -> [AnnualDividend] {
        
        var dividendsSortedByYear = [(year: Int, dividends: [DividendElement])]()
        
        for dividend in dividends {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yy-MM-dd"
            guard let date = dateFormatter.date(from: dividend.registryclosedate) else {
                Logger.log(error: "Unable to create a date from \(dividend.registryclosedate)")
                return []
            }
            
            guard let year = Date.yearFromDate(date) else {
                Logger.log(error: "Unable to get the year from \(date)")
                return []
            }
            
            if let yearIndex = dividendsSortedByYear.firstIndex(where: { $0.year == year }) { 
                dividendsSortedByYear[yearIndex].dividends.append(dividend)
            } else {
                dividendsSortedByYear.append((year, [dividend]))
            }
        }
        
        let annualDividends = dividendsSortedByYear.map({ AnnualDividend(year: $0.year, payouts: $0.dividends) })
        
        return annualDividends
    }
    
    ///Returns the total dividend payout for the last year from the local storage
    static func getLastYearDividend(for ticker: String) -> Double? {
        
        /*We have two cases in total:
         1) Get local dividends from the data fetched from the MOEX API
         2) Get local dividends from the plist files
        */
        
        if let moexDividend = MoexDataManager.getDividendDataLocally(forTicker: ticker)?.dividends {
            let groupedDividends = groupDividendsByYear(moexDividend)
            
            if let lastYearDividend = groupedDividends.first(where: { $0.year == Date.lastYear }) {
                return lastYearDividend.totalAnnualPayout
            } else {
                Logger.log(warning: "No last year dividend for \(ticker) in Moex Data")
            }
        }
        
        guard let lastDividend = SmartlabDataService.getLocalSmartlabData(for: [ticker])[safe: 0]?.getDividend()?.first(where: { $0.year == Date.lastYear })?.value //FinancialDataManager.getDividends(for: ticker)?.first(where: {$0.year == Date.lastYear})?.value
        else {
            Logger.log(error: "No plist dividend for \(ticker)")
            return nil
        }
        
        return lastDividend
        
//        guard let shareCount = try? FinancialDataManager.numberOfSharesFor(ticker: ticker) else {
//            Logger.log(error: "No share count for \(ticker)")
//            return nil
//        }
//
//        if ticker.last == "P" {
//            return shareCount.numberOfPreferredShares != nil ? lastDividend * 1_000_000_000 / Double(shareCount.numberOfPreferredShares!) : nil
//        } else {
//            return lastDividend * 1_000_000_000 / Double(shareCount.numberOfOrdinaryShares)
//        }
        
        
        
//        if let dividends = MoexDataManager.getDividendDataLocally(forTicker: ticker)?[1].dividends {
//            Logger.log(error: "No local dividends for \(ticker)")
//            return nil
//        } else if let dividendsFromPlist = FinancialDataManager.getDividends(for: ticker) {
//
//        } else {
//
//            let annualDividends = groupDividendsByYear(dividends)
//
//            guard let lastYearDividend = annualDividends.first(where: { $0.year == Date.lastYear }) else {
//                Logger.log(error: "No dividends for \(Date.lastYear) for \(ticker)")
//                return nil
//            }
//
//            return lastYearDividend.totalAnnualPayout
//        }
    }
}


extension MoexDividendService {
    static func dividendYieldForAllCompanies(with quotes: [SimpleQuote]) -> [DividendYield] {
        guard quotes.count > 0 else { return [] }
        
        var dividends = [DividendYield]()
        
        let tickers = C.Tickers.allTickerSymbolsWithNames().map(\.ticker)
        
        for ticker in tickers {
            
            guard let currentQuote = quotes.first(where: { $0.ticker == ticker }) else {
                Logger.log(error: "No quote for \(ticker)")
                continue
            }
            //In case we have a fixed dividend for the company
            if let fixedDividend = DividendCalculator.fixedDividendPerShare(for: currentQuote.ticker) {
                let ordinaryShareYield = fixedDividend / currentQuote.quote * 100
                let companyName: String? = C.Tickers.companyName(for: currentQuote.ticker)
                dividends.append(.init(ticker: companyName ?? currentQuote.ticker, yield: ordinaryShareYield, isFixed: true))
                //In case we don't have a fixed dividend for the company
            } else {
                //Ordinary shares case
                guard let ordinaryShareDividends = getLastYearDividend(for: currentQuote.ticker)
                else { Logger.log(error: "Dividend Service: No dividends for \(currentQuote.ticker)"); continue }
                
                let ordinaryShareYield = ordinaryShareDividends / currentQuote.quote * 100
                let companyName: String? = C.Tickers.companyName(for: currentQuote.ticker)
                dividends.append(.init(ticker: companyName ?? currentQuote.ticker, yield: ordinaryShareYield, isFixed: false))
            }
        }
        
        return dividends
    }
}

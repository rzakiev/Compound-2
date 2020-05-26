//
//  MoexDataManager.swift
//  Compound 2
//
//  Created by Robert Zakiev on 24.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct MoexDataManager {
    @available(*, unavailable)
    fileprivate init() { Logger.log(error: "Initializing an instance of \(Self.self)") }
    
    ///Updated all data that can be retrieved via MOEX API and saved locally
    static func updateAllLocalDataFromMoex() {
        fetchDividendsForAllCompaniesAndSaveItLocally()
        fetchAndSaveAllTradedTickerSymbols()
    }
}

extension MoexDataManager {
    static func fetchDividendsForAllCompaniesAndSaveItLocally() {
        guard let tickerSymbols = getTickerSymbolsFromLocalStorage() else {
            Logger.log(error: "No ticker symbols found")
            return
        }
        
        DispatchQueue.global(qos: .background).async {
            for ticker in tickerSymbols {
                guard let dividends = DividendService.fetchDividends(forTicker: ticker) else {
                    Logger.log(error: "Unable to fetch dividends for \(ticker)")
                    continue
                }
                saveDividendDataLocally(dividends, forTicker: ticker)
            }
        }
    }
}

//MARK: - Saving and Retrieving Local Dividends
extension MoexDataManager {
    static let dividendSubDirectory = "Dividends/"
    ///Saves dividend data for a  specific company to the local storage
    static func saveDividendDataLocally(_ dividends: Dividends, forTicker ticker: String) {
        
        let fileManager = FileManager.default
        if let applicationSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let newSubDirectoryPath = applicationSupportDirectory.appendingPathComponent(dividendSubDirectory)
            if fileManager.fileExists(atPath: newSubDirectoryPath.path) == false {
                do { try fileManager.createDirectory(atPath: newSubDirectoryPath.path, withIntermediateDirectories: true, attributes: nil) }
                catch { Logger.log(error: "Unable to create a dividends subdirectory \(error)") }
            }
        }
        
        guard dividends.count > 0 else {
            Logger.log(error: "Attempting to save dividends containing zero entries for \(ticker)")
            return
        }
        
        guard let url = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true).appendingPathComponent(dividendSubDirectory + "\(ticker).json")
            else {
                Logger.log(error: "Unable to generate a URL to save a dividend json for \(ticker)")
                return
        }
        
        guard let encodedDividends = try? JSONEncoder().encode(dividends) else {
            Logger.log(error: "Unable to encode the dividends for \(ticker)")
            return
        }
        
        do { try encodedDividends.write(to: url) }
        catch { Logger.log(error: "Dividend saving error: \(error)") }
        Logger.log(operation: "Saved the dividends for \(ticker)")
    }
    
    ///Retrieves  dividend data for a  specific company from the local storage
    static func getDividendDataLocally(forTicker ticker: String) -> Dividends? {
        
        guard let url = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true).appendingPathComponent(dividendSubDirectory + "\(ticker).json") else { return nil }
        
        guard (try? url.checkResourceIsReachable()) == true else { return nil }
        
            
        guard let data = try? Data(contentsOf: url) else { return nil }
            
        guard let dividends = try? JSONDecoder().decode(Dividends.self, from: data) else { return nil }
        
        return dividends
    }
}


//MARK: - Saving and Retrieving Quotes
extension MoexDataManager {
    
    static let tickerSymbolsDirectory = "Tickers/"
    static let tickersFileName = "allTickers.json"
    
    static func fetchAndSaveAllTradedTickerSymbols() {
        DispatchQueue.global().async {
            let tickerSymbols = QuoteService.shared.getAllMoexQuotes().map(\.ticker)
            saveTickerSymbolsToLocalStorage(tickerSymbols)
        }
    }
    
    static func saveTickerSymbolsToLocalStorage(_ tickers: [String]) {
        let fileManager = FileManager.default
        if let applicationSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let newSubDirectoryPath = applicationSupportDirectory.appendingPathComponent(tickerSymbolsDirectory)
            if fileManager.fileExists(atPath: newSubDirectoryPath.path) == false {
                do { try fileManager.createDirectory(atPath: newSubDirectoryPath.path, withIntermediateDirectories: true, attributes: nil) }
                catch { Logger.log(error: "Unable to create a ticker symbol subdirectory \(error)") }
            }
        }
        
        guard tickers.count > 0 else {
            Logger.log(error: "Attempting to save tickers containing zero entries.")
            return
        }
        
        guard let url = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true).appendingPathComponent(tickerSymbolsDirectory + tickersFileName)
            else {
                Logger.log(error: "Uable to generate a URL for the ticker symbols directory")
                return
        }
        
        guard let encodedDividends = try? JSONEncoder().encode(tickers) else {
            Logger.log(error: "Unable to encode the ticker symbols array: \(tickers)")
            return
        }
        
        do { try encodedDividends.write(to: url) }
        catch { Logger.log(error: "Dividend saving error: \(error)") }
        Logger.log(operation: "Saved the ticker symbols")
    }
    
    
    static func getTickerSymbolsFromLocalStorage() -> [String]? {
        guard let url = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true).appendingPathComponent(tickerSymbolsDirectory + tickersFileName) else { return nil }
        
        guard (try? url.checkResourceIsReachable()) == true else { return nil }
        
            
        guard let data = try? Data(contentsOf: url) else { return nil }
            
        guard let tickerSymbols = try? JSONDecoder().decode([String].self, from: data) else { return nil }
        
        return tickerSymbols
    }
}

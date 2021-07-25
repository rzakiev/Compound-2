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
    
    ///Updates all local data that can be retrieved via MOEX API
    static func updateAllLocalDataFromMoex() {
        fetchAllTradedTickerSymbolsAndSaveThemLocally()
        fetchAllSecuritiesInfoAndSaveItLocally()
        //        fetchDividendsForAllCompaniesAndSaveItLocally()
    }
}

//MARK: - Fetching dividends from the Moscow Exchange API
extension MoexDataManager {
    static func fetchDividendsForAllCompaniesAndSaveItLocally() {
        let tickerSymbols = C.Tickers.allTickerSymbolsWithNames().map(\.ticker)
        
        MoexDividendService.fetchDividendsForSomeCompaniesAsync(tickers: tickerSymbols) { newDividends in
            guard newDividends.count > 0 else { return }
            newDividends.forEach({ newDividend in
                saveDividendDataLocally(newDividend.dividends, forTicker: newDividend.ticker)
            })
        }
    }
}

//MARK: - Saving and Retrieving Local Dividends
extension MoexDataManager {
    private static let dividendSubDirectory = "Dividends/"
    ///Saves dividend data for a  specific company to the local storage
    static func saveDividendDataLocally(_ dividends: MoexDividends, forTicker ticker: String) {
        
        let fileManager = FileManager.default
        if let applicationSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let newSubDirectoryPath = applicationSupportDirectory.appendingPathComponent(dividendSubDirectory)
            if fileManager.fileExists(atPath: newSubDirectoryPath.path) == false {
                do { try fileManager.createDirectory(atPath: newSubDirectoryPath.path, withIntermediateDirectories: true, attributes: nil) }
                catch { Logger.log(error: "Unable to create a dividends subdirectory \(error)") }
            }
        }
        
        guard dividends[1].dividends != nil else { return }
        
        guard dividends[1].dividends!.count > 0 else {
            Logger.log(warning: "Attempting to save dividends containing zero entries for \(ticker)")
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
    static func getDividendDataLocally(forTicker ticker: String) -> MoexDividend? {
        
        guard let url = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true).appendingPathComponent(dividendSubDirectory + "\(ticker).json") else { return nil }
        
        guard (try? url.checkResourceIsReachable()) == true else { return nil }
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        guard let dividends = try? JSONDecoder().decode(MoexDividends.self, from: data) else { return nil }
        
        return dividends.last
    }
    
    static func getDividendDataLocallyForAllCompanies() -> [MoexDividend] {
        var dividendsForAllCompanies = [MoexDividend]()
        
        let publicCompanies = C.Tickers.allTickerSymbolsWithNames().map(\.ticker)
        
        for ticker in publicCompanies {
            guard let localDividend = getDividendDataLocally(forTicker: ticker) else { continue }
            dividendsForAllCompanies.append(localDividend)
        }
        
        return dividendsForAllCompanies
    }
}

//MARK: - Saving and Retrieving Quotes
extension MoexDataManager {
    
    private static let tickerSymbolsDirectory = "Tickers/"
    private static let tickersFileName = "allTickers.json"
    
    static func fetchAllTradedTickerSymbolsAndSaveThemLocally() {
        DispatchQueue.global(qos: .background).async {
            let tickerSymbols = MoexQuoteService.shared.getAllMoexQuotes().map(\.ticker)
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

//MARK: - Saving and Retrieving Securities Info
extension MoexDataManager {
    
    private static let securitiesInfoDirectory = "Securities/"
    private static let securitiesInfoFileName = "allSecuritiesInfo.json"
    
    //Asynchronously fetched securities info and saves it locally
    static func fetchAllSecuritiesInfoAndSaveItLocally() {
        SecurityInfoService.fetchSecuritiesInfoAsync(completion: { securities in
            guard securities != nil else {
                Logger.log(error: "Attempting to save nil Securities info")
                return
            }
            saveSecuritiesInfoLocally(securities!)
        })
    }
    
    private static func saveSecuritiesInfoLocally(_ securities: SecuritiesInfo) {
        let fileManager = FileManager.default
        if let applicationSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let newSubDirectoryPath = applicationSupportDirectory.appendingPathComponent(securitiesInfoDirectory)
            if fileManager.fileExists(atPath: newSubDirectoryPath.path) == false {
                do { try fileManager.createDirectory(atPath: newSubDirectoryPath.path, withIntermediateDirectories: true, attributes: nil) }
                catch { Logger.log(error: "Unable to create a securities info symbol subdirectory \(error)") }
            }
        }
        
        guard securities.data.count > 0 else {
            Logger.log(error: "Attempting to save securities info containing zero entries.")
            return
        }
        
        guard let url = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true).appendingPathComponent(securitiesInfoDirectory + securitiesInfoFileName)
            else {
                Logger.log(error: "Uable to generate a URL for the securities info directory")
                return
        }
        
        guard let encodedSecuritiesInfo = try? JSONEncoder().encode(securities) else {
            Logger.log(error: "Unable to encode the ticker symbols array: \(securities)")
            return
        }
        
        do { try encodedSecuritiesInfo.write(to: url) }
        catch { Logger.log(error: "Securities info saving error: \(error)") }
        Logger.log(operation: "Saved the securities info")
    }
    
    static func getSecuritiesInfoFromLocalStorage() -> SecuritiesInfo? {
        guard let url = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true).appendingPathComponent(securitiesInfoDirectory + securitiesInfoFileName) else { return nil }
        
        guard (try? url.checkResourceIsReachable()) == true else { return nil }
        
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        guard let securitiesInfo = try? JSONDecoder().decode(SecuritiesInfo.self, from: data) else { return nil }
        
        return securitiesInfo
    }
}

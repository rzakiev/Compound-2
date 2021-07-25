//
//  SmartlabFinancialDataService.swift
//  Compound 2
//
//  Created by Robert Zakiev on 15.12.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

///Fetches companies' financial data like revenue and dividends from Smartlab.ru and stores it locally
struct SmartlabDataService {@available (*, unavailable)
    fileprivate init() { Logger.log(error: "Initializing an instance of \(Self.self) which is unnecessary.") }
}




//MARK: - Interface
extension SmartlabDataService {
    
    static func fetchDataForAllTickers() async {
        let allTickers = C.Tickers.allTickerSymbols()
        await fetchData(for: allTickers)
    }
    
    ///Asynchronously fetch smartlab data for a collection of ticker symbols
    static func fetchData(for tickers: [String], saveToLocalStorage: Bool = true) async {
        
        for ticker in tickers {
            
            guard let dataSourceURL = URL(string: dataDownloadURL(for: ticker)) else {
                Logger.log(error: "Unable to instantiate an instance of URL using \(dataDownloadURL(for: ticker))")
                return
            }
            
            guard let (downloadedCSV, _) = try? await URLSession.shared.data(from: dataSourceURL) else {
                Logger.log(error: "Unable to download the CSV file for \(ticker)")
                return
            }
            
            let csvDataAsString = String(decoding: downloadedCSV, as: UTF8.self)
            
            guard let parsedData = parseSmartlabCSV(string: csvDataAsString, ticker: ticker) else {
                Logger.log(error: "\(Self.self) Couldn't parse the CSV file for \(ticker)")
                return
            }
            
            if saveToLocalStorage {
                saveSmartLabDataLocally(parsedData, for: ticker)
            }
            
        }
        
    }
}

//MARK: - Working with the file system
extension SmartlabDataService {
    
    ///Retrieving the locally stored smartlab data for multiple tickers
    static func getLocalSmartlabData(for tickers: [String]) -> [SmartlabData] {
        
        var localSmartlabData = [SmartlabData?]()
        
        tickers.forEach { ticker in
            localSmartlabData.append(getLocalSmartLabData(for: ticker))
        }
        
        return localSmartlabData.compactMap({ $0 })
    }
    
    ///Retrieving the locally stored smartlab data for a single ticker
    private static func getLocalSmartLabData(for ticker: String) -> SmartlabData? {
        guard let url = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: true).appendingPathComponent(smartlabDataDirectory + ticker + ".json") else { return nil }
        
        guard (try? url.checkResourceIsReachable()) == true else { return nil }
        
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        guard let decodedSmartlabData = try? JSONDecoder().decode(SmartlabData.self, from: data) else { return nil }
        
        return decodedSmartlabData
    }
    
    ///Saving the fetched smartlab data to the local storage
    private static func saveSmartLabDataLocally(_ data: SmartlabData, for ticker: String) {
        
        let fileManager = FileManager.default
        if let applicationSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let newSubDirectoryPath = applicationSupportDirectory.appendingPathComponent(smartlabDataDirectory)
            if fileManager.fileExists(atPath: newSubDirectoryPath.path) == false {
                do { try fileManager.createDirectory(atPath: newSubDirectoryPath.path, withIntermediateDirectories: true, attributes: nil) }
                catch { Logger.log(error: "Unable to create a smartlab data subdirectory \(error)") }
            }
        }
        
        guard data.values.count > 0 else {
            Logger.log(error: "Attempting to save smart lab data with zero entries.")
            return
        }
        
        guard let url = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                        in: .userDomainMask,
                                                        appropriateFor: nil,
                                                        create: true).appendingPathComponent(smartlabDataDirectory + ticker + ".json")
        else {
            Logger.log(error: "Uable to generate a URL for the smartlab data info directory")
            return
        }
        
        guard let encodedSecuritiesInfo = try? JSONEncoder().encode(data) else {
            Logger.log(error: "Unable to encode the smart lab data for: \(ticker)")
            return
        }
        
        do { try encodedSecuritiesInfo.write(to: url) }
        catch { Logger.log(error: "Smartlab data encoding error: \(error)") }
        Logger.log(operation: "Saved the smartlab data for \(ticker)")
    }
}



//MARK: - CSV Parser
private extension SmartlabDataService {
    ///Parses CSV files fetched from smartlab and converts them into instances of SmartlabData
    private static func parseSmartlabCSV(string: String, ticker: String) -> SmartlabData? {
        
        //Parsing the csv and splitting it into arrays
        let csvRows = string.split(separator: "\n").map({ $0.split(separator: ";") })
        
        guard let headers = csvRows[safe: 0], headers.count > 0 else {
            Logger.log(error: "No headers in the CSV file")
            return nil
        }
        
        var values = [String: [FinancialFigure]]()
        
        for row in csvRows {
            
            guard let uncastIndicator = row[safe: 0] else { continue }
            let currentIndicator = String(uncastIndicator)
            
            let indicatorIsRequired: Bool = ["\"Выручка, млрд руб\"", "\"Див.выплата, млрд руб\""].contains(currentIndicator)
            
            if indicatorIsRequired == false { continue }
            
            
            let rowsToParse =  Array(row.suffix(6).map({ String($0) }))
            let yearsToParse = Array(headers.suffix(6).map({ String($0) }))
            
            let extraItemsInRow = rowsToParse.count - yearsToParse.count
            
            let figures = parse(row: rowsToParse.dropLast(extraItemsInRow), years: yearsToParse)
            
            values[currentIndicator] = figures
        }
        
        return SmartlabData(ticker: ticker, values: values)
    }
    
    private static func parse(row: [String], years: [String]) -> [FinancialFigure] {
        
        var figures = [FinancialFigure]()
        
        guard row.count >= years.count + 1 else {
            Logger.log(error: "Mismatch between the rows and the years count")
            return []
        }
        
        for i in 0..<row.count {
            guard let year = Int(years[i].replacingOccurrences(of: ",", with: ".")) else {
                Logger.log(error: "Unable to pass the year \(years[i])")
                continue
            }
            
            guard let value = Double(row[i].replacingOccurrences(of: ",", with: ".")) else {
                Logger.log(error: "Unable to pass the value \(row[i])")
                continue
            }
            figures.append(.init(year: year, value: value))
        }
        
        return figures
    }
}

//MARK: - STRICTLY FOR LOCAL TESTS
private extension SmartlabDataService {
    //    private static func parseLocalData(for ticker: String) -> SmartlabData? {
    //        guard let csvPath = Bundle.main.path(forResource: ticker, ofType: "csv",
    //                                               inDirectory: "Corporate Resources")
    //        else {
    //            Logger.log(error: "No local CSV file found for \(ticker)")
    //            return nil
    //        }
    //
    //        guard let csvData = FileManager.default.contents(atPath: csvPath) else {
    //            Logger.log(error: "Couldn't load the plist data from path: \(csvPath)")
    //            return nil
    //        }
    //
    //        guard let parsedString = String(data: csvData, encoding: .utf8) else {
    //            Logger.log(error: "Noooooooooo")
    //            return nil
    //        }
    //
    //        return parseSmartlabCSV(string: parsedString, ticker: ticker)
    //    }
}

//MARK: - Constants
private extension SmartlabDataService {
    
    private static let downloadBaseURL = "https://smart-lab.ru/q/"
    
    private static let downloadEndURL = "/f/y/MSFO/download/"
    
    ///The directory that will store the local smartlab data
    private static let smartlabDataDirectory = "SmartlabData/"
    
    ///Returns the URL at which financial data can be downloaded from Smartlab for the specified ticker symbol
    static func dataDownloadURL(for ticker: String) -> String {
        return downloadBaseURL + ticker + downloadEndURL
    }
}

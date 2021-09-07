//
//  PolygonAPI.swift
//  Compound 2
//
//  Created by Robert Zakiev on 06.07.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation

///Service responsible for the retrieval of
struct PolygonDataService {
    @available(*, unavailable)
    fileprivate init() { Logger.log(error: "Initializaing an instance of \(Self.self)") }
    
    /*These two properties are used to track the number and date of requests made to PolygonAPI which only allows 5 requests per minute
     on the free plan.*/
    static var lastRequestTime: Date? = nil
    static var requestCounter: Int = 0
}

//MARK: - Financial Data methods
//Methods dealing with fetching companies' financial data via Polygon API as well as saving and retrieveing it locally
extension PolygonDataService {
    ///Fetches the financial data (revenue, net income, etc.) from Polygon API and then saves it locally
    @discardableResult
    static func fetchHistoricalFinancialData(for ticker: String, saveToLocalStorage: Bool = true) async -> PolygonData? {
        
        let apiRequestPreferences = PolygonDataService.RequestPreferences(type: .YA,
                                                                          sortBy: .calendarDate)
        
        guard let dataSourceURL = financialDataDownloadURL(for: ticker, preferences: apiRequestPreferences) else {
            Logger.log(error: "Unable to instantiate an instance of URL to retrieve financial data from Polygon for \(ticker) ")
            return nil
        }
        
        //Authentication documentation: https://polygon.io/docs/getting-started
        var urlRequest = URLRequest(url: dataSourceURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(C.PolygonAPI.key)", forHTTPHeaderField: "Authorization")
        
        guard let (rawPolygonData, _) = try? await URLSession.shared.data(for: urlRequest) else {
            Logger.log(error: "Unable to get the financial data via polygon API for \(ticker)")
            return nil
        }
        
        guard let polygonAPIresponse = try? JSONDecoder().decode(PolygonFinancialDataAPIResponse.self, from: rawPolygonData) else {
            print(String(data: rawPolygonData, encoding: .utf8) ?? "Unable to convert raw Polygon data into a String for \(ticker)")
            Logger.log(error: "Unable to decode Polygon API output into an instance of PolygonFinancialDataAPIResponse")
            return nil
        }
        
        if saveToLocalStorage {
            if let castAPIResponse = polygonAPIresponse.convertToPolygonData() {
                savePolygonDataLocally(castAPIResponse)
            } else {
                Logger.log(error: "Unable to uncast the polygon API response for \(ticker)")
            }
        }
        
        return nil
    }
    
    @discardableResult
    static func fetchHistoricalFinancialData(for tickers: [String], saveToLocalStorage: Bool = true) async -> [PolygonData] {
        //Testing with ["AMZN", "KO", "PBF", "BIDU", "BABA", "OXY"]
        var polygonData = [PolygonData] ()
        
        for ticker in tickers {
            if authorizedToDownloadData() == false {
                Logger.log(warning: "Suspending the Polygon data service for 60 seconds")
                await Task.sleep(60.inNanoSeconds)
                self.requestCounter = 0
            }
            
            let data = await fetchHistoricalFinancialData(for: ticker, saveToLocalStorage: saveToLocalStorage)
            if data != nil { polygonData.append(data!) }
            
            lastRequestTime = Date() //Registering the response time so that we can later track if more than 5 requests have been made in 1 min
            requestCounter += 1
        }
        
        return polygonData
    }
    
    @discardableResult
    static func fetchHistoricalFinancialDataForAllTickers(saveToLocalStorage: Bool = true) async -> [PolygonData] {
        return await fetchHistoricalFinancialData(for: C.Tickers.allForeignTickerSymbols())
    }
    
    static func savePolygonDataLocally(_ polygonData: PolygonData) {
        guard let encodedData = try? JSONEncoder().encode(polygonData) else {
            Logger.log(error: "Unable to encode polygon data")
            return
        }
        
        FileManager.saveFileToApplicationSupport(in: C.PolygonAPI.financialDataDirectory, name: polygonData.ticker, content: encodedData) 
    }
    
    static func getPolygonDataLocally(for ticker: String) -> PolygonData? {
    
        guard let rawData = FileManager.getFileFromApplicationSupport(in: C.PolygonAPI.financialDataDirectory, name: ticker) else {
            return nil
        }
        
        guard let decodedData = try? JSONDecoder().decode(PolygonData.self, from: rawData) else {
            Logger.log(error: "Unable to decode an instance PolygonData from local data for \(ticker)")
            return nil
        }
        
        return decodedData
    }
}

extension PolygonDataService {
    
    ///Generates the URL of the API endpoint that returns the financial data for the given company
    static func financialDataDownloadURL(for ticker: String, preferences: PolygonDataService.RequestPreferences) -> URL? {
        //The new experimental Polygon endpoint. It'll soon replace the old one.
        /*var polygonDataDownloadURL = "https://api.polygon.io/vX/reference/financials?"
        
        polygonDataDownloadURL += "ticker=\(ticker)"

        polygonDataDownloadURL += "&timeframe=\(preferences.timeframe.rawValue)"
        
        polygonDataDownloadURL += "&order=\(preferences.order.rawValue)"
        
        polygonDataDownloadURL += "&sort=\(preferences.sortBy.rawValue)"
        
        return URL(string: polygonDataDownloadURL)*/
        
        //The old endpoint:
        var url = C.PolygonAPI.baseURL + "reference/financials/" + ticker + "?"
        
        url += "&type=\(preferences.type.rawValue)"
        url += "&sort=\(preferences.sortBy.rawValue)"
        
        return URL(string: url)
    }
}

//MARK: - Data Updating Criteria
extension PolygonDataService {
    static func authorizedToDownloadData() -> Bool {
        
        guard requestCounter >= 5 else { return true }
        
        guard let lastRequestDispatchTime = lastRequestTime else { return true }
        
        guard let sixtySecondsDidElapse = Date.more(than: 60, .second, elapsedSince: lastRequestDispatchTime) else { return false }
        
        return sixtySecondsDidElapse
    }
}



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
            Logger.log(error: "Unable to decode Polygon API output into an instance of PolygonFinancialDataAPIResponse")
            return nil
        }
        
        if saveToLocalStorage {
            if let castAPIResponse = polygonAPIresponse.convertToPolygonData() {
                savePolygonDataLocally(castAPIResponse)
            } else {
                Logger.log(error: "Unable to uncase the polygon API response for \(ticker)")
            }
        }
        
        return nil
    }
    
    @discardableResult
    static func fetchHistoricalFinancialData(for tickers: [String], saveToLocalStorage: Bool = true) async -> [PolygonData] {
        
        var polygonData = [PolygonData] ()
        
        for ticker in tickers {
            let data = await fetchHistoricalFinancialData(for: ticker, saveToLocalStorage: saveToLocalStorage)
            if data != nil { polygonData.append(data!) }
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

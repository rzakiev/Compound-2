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

extension PolygonDataService {
    @discardableResult
    static func fetchHistoricalFinancialData(for ticker: String) async -> PolygonData? {
        
        guard let dataSourceURL = financialDataDownloadURL(for: ticker) else {
            Logger.log(error: "Unable to instantiate an instance of URL using \(String(describing: financialDataDownloadURL(for: ticker)))")
            return nil
        }
        
        //Authentication documentation: https://polygon.io/docs/getting-started
        var urlRequest = URLRequest(url: dataSourceURL)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer \(C.PolygonAPI.key)", forHTTPHeaderField: "Authorization")
        
        guard let (downloadedCSV, _) = try? await URLSession.shared.data(for: urlRequest) else {
            Logger.log(error: "Unable to download the CSV file for \(ticker)")
            return nil
        }
        
        return nil
    }
}


extension PolygonDataService {
    static func financialDataDownloadURL(for ticker: String, timeframe: PolygonDataService.TimeFrame = .annual) -> URL? {
        //This endpoint is an experimental one, the URL might soon change. You'll probably have to use C.PolygonAPI.baseURL in the future.
        var polygonDataDownloadURL = "https://api.polygon.io/vX/reference/financials?"
        
        polygonDataDownloadURL += "ticker=\(ticker)" //adding a query parameter `ticker`

        polygonDataDownloadURL += "&timeframe=\(timeframe.rawValue)"
        
        
        //ticker=GAZP&timeframe=annual&order=asc&sort=period_of_report_date&apiKey=kATfwcnbHHRPIxQgOKRF0iFYT0hWx62i
        
        return URL(string:polygonDataDownloadURL)
    }
}

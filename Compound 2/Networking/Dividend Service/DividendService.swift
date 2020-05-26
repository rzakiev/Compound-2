//
//  DividendService.swift
//  Compound 2
//
//  Created by Robert Zakiev on 20.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

final class DividendService: ObservableObject {
    
    @available (*, unavailable)
    fileprivate init() {
        Logger.log(operation: "DS: Initializing the shared instance of the dividend service")
    }
    
//    public static let shared = DividendService()
    
//    @Published final private(set) var allDividends: [Dividends] = []
}

//MARK: - Fetching dividends
extension DividendService {
    private static let moexDividendBaseURL = "https://iss.moex.com/iss/securities/"
    private static let moexDividendURLEnd = "/dividends.json?iss.meta=off&iss.json=extended"
    
    private static func dividendSourceURL(forTicker ticker: String) -> String {
        return moexDividendBaseURL + ticker + moexDividendURLEnd
    }
    
    ///Returns the dividends paid out by the specifie company. Synchronous call.
    static func fetchDividends(forTicker ticker: String) -> Dividends? {
        
        let dividendSourceURL = DividendService.dividendSourceURL(forTicker: ticker)
        
        guard let url = URL(string: dividendSourceURL) else {
            Logger.log(error: "Unable to create a URL struct using the string: \(dividendSourceURL)")
            return nil
        }
        
        guard let jsonData = try? Data(contentsOf: url) else {
            Logger.log(error: "Unable to instantiate an instance of type Data from the URL: \(url)")
            return nil
        }
        
        let dividends: Dividends? = MoexDataParser.parseDividendJSON(jsonData)
        
        return dividends
    }
    
    ///Returns the dividends paid out by the specifie company. Asynchronous call.
    static func fetchDividendsAsync(forTicker ticker: String, completion: @escaping (Dividends?) -> Void) {
        DispatchQueue.global().async {
            let dividends = fetchDividends(forTicker: ticker)
            DispatchQueue.global().async {
                completion(dividends)
            }
        }
    }
}






//

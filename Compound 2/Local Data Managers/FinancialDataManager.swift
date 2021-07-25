//
//  FinancialData.swift
//  Compound 2
//
//  Created by Robert Zakiev on 04.08.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation


struct CompanyName: Identifiable {
    var id = UUID()
    let name: String
    let ticker: String
}

//struct FinancialDataManager {
//    
//    static func listOfAllCompanies() -> [CompanyName] {
//        return C.Tickers.allTickerSymbolsWithNames().map({ CompanyName(name: $0.value , ticker: $0.key) })
//    }
//}

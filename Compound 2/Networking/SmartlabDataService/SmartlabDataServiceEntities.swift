//
//  SmartlabDataServiceEntities.swift
//  Compound 2
//
//  Created by Robert Zakiev on 15.12.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

//Entities utilized by SmartlabFinancialDataService
extension SmartlabDataService {
    
    struct SmartlabData: Codable, FinancialData {
        
        let ticker: String
        let values: [String: [FinancialFigure]]
    }
}

extension SmartlabDataService.SmartlabData {
    func getSpecificIndicator(_ indicator: String) -> [FinancialFigure]? {
        return values[indicator]
    }
    
    func getDividend() -> [FinancialFigure]? {
        return values.first(where: { $0.key.contains("Див.выплата") })?.value
    }
    
    func getRevenue() -> [FinancialFigure]? {
        return values.first(where: { $0.key.contains("Выручка") })?.value
    }
    
    func getNetIncome() -> [FinancialFigure]? {
        return values.first(where: { $0.key.contains("Чистая прибыль") })?.value
    }
    
    func getFCF() -> [FinancialFigure]? {
        return nil
    }
}

//Protocol that should implemented by structs that house companies' financial data
protocol FinancialData {
    var ticker: String { get }
    var values: [String: [FinancialFigure]] { get }
    
    func getRevenue() -> [FinancialFigure]?
    
    func getNetIncome() -> [FinancialFigure]?
    
    func getDividend() -> [FinancialFigure]?
    
    func getFCF() -> [FinancialFigure]?
}

////MARK: - Protocol Implementations
//extension SmartlabDataService: CustomStringConvertible {
//    var description: String {
//        return
//    }
//}

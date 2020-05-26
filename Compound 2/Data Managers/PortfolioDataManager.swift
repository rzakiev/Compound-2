//
//  PortfolioDataManager.swift
//  Compound 2
//
//  Created by Robert Zakiev on 30.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct PortfolioDataManager {
    
    static func savePortfolio(_ portfolio: Portfolio) throws {
        
        guard portfolio.positions.count > 0 else {
            Logger.log(error: "Trying to save an empty portfolio")
            throw PortfolioSaveError.tryingToSaveEmptyPortfolio
        }
        
        guard let url = try? FileManager.default.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true).appendingPathComponent("portfolio.json")
        else {
            throw PortfolioSaveError.unableToSavePortfolio(reason: "Unable to get url")
        }
        
        guard let encodedPortfolio = try? JSONEncoder().encode(portfolio) else {
            Logger.log(error: "Unable to encode the portfolio")
            throw PortfolioSaveError.unableToSavePortfolio(reason: "Unable to encode the portfolio")
        }
        
        do { try encodedPortfolio.write(to: url) }
        catch { print(error) }
    }
    
    ///Returns the trader's local portfolio
    static func getLocalPortfolio() -> Portfolio? {
       
        guard let url = try? FileManager.default.url(for: .documentDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true).appendingPathComponent("portfolio.json") else { return nil }
        
        guard (try? url.checkResourceIsReachable()) == true else { return nil }
        
            
        guard let data = try? Data(contentsOf: url) else { return nil }
            
        guard let portfolio = try? JSONDecoder().decode(Portfolio.self, from: data) else { return nil }
        
        return portfolio
    }
//    static func convertDictIntoPofrtolioStruct(_ dictionary: ) -> Portfolio ? {
//
//    }
}

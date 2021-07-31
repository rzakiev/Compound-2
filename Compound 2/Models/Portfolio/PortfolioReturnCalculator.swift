//
//  PortfolioReturnCalculator.swift
//  PortfolioReturnCalculator
//
//  Created by Robert Zakiev on 25.07.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation

/*
 This purpose of this struct is to calculate the historical returns of a portfolio and compare them to those of indices
 */

struct PortfolioReturnCalculator {
    @available(*, unavailable)
    fileprivate init() { Logger.log(error: "Initializing an instance of \(Self.self)") }
}

extension PortfolioReturnCalculator {
    static func calculatePortfolioReturn() {
        
    }
}

//MARK: - File system methods
extension PortfolioReturnCalculator {
    ///Loads the portfolio returns from the local data
    static func loadPortfolioReturns() -> [PortfolioReturns] {
        let portfolioReturnData = FileManager.getFilesInMainBundle(inDirectory: C.PortfolioReturnsVariables.returnDirectory)
        
        guard portfolioReturnData.count > 0 else {
            Logger.log(error: "No portfolio returns data found")
            return []
        }
        
        var portfolioReturns = [PortfolioReturns]()
        
        for data in portfolioReturnData {
            guard let portfolioReturn = try? JSONDecoder().decode(PortfolioReturns.self, from: data) else {
                Logger.log(error: "Unable to decode the data into an instance of PortfolioReturns")
                continue
            }
            portfolioReturns.append(portfolioReturn)
        }
        
        return portfolioReturns
    }
}

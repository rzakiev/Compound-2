//
//  PortfolioReturnCalculator.swift
//  PortfolioReturnCalculator
//
//  Created by Robert Zakiev on 25.07.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation

struct PortfolioReturnCalculator {
    @available(*, unavailable)
    fileprivate init() { Logger.log(error: "Initializing an instance of \(Self.self) which only contains static methods") }
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
        
        for brokerPortfolio in portfolioReturnData {
            guard let portfolioReturn = try? JSONDecoder().decode(PortfolioReturns.self, from: brokerPortfolio) else {
                Logger.log(error: "Unable to decode the data into an instance of PortfolioReturns")
                continue
            }
            portfolioReturns.append(portfolioReturn)
        }
        
        return portfolioReturns
    }
}

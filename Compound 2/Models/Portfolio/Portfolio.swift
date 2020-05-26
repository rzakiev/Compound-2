//
//  Portfolio.swift
//  Compound 2
//
//  Created by Robert Zakiev on 30.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct Portfolio: Codable {
    
    let name: String
    
    var positions: [Position]
    
    ///Default initializer
    init(name: String, positions: [Position]) {
        self.name = name
        self.positions = positions
    }
    
    ///Use this initializer to laod a portfolio from storage
    init?(fromLocalStorage: Bool) {
        guard let portfolioFromStorage = PortfolioDataManager.getLocalPortfolio() else { return nil }
        self = portfolioFromStorage
        self.positions = portfolioFromStorage.positions.sorted(by: >)
    }
}

//MARK: - Dividends
extension Portfolio {
    var grossDividendFlow: Double {
        var totalDividendSum = 0.0
        totalDividendSum += self.positions.map(\.expectedDividend).compactMap({ $0 }).reduce(0, +)
        return totalDividendSum
    }
}

//MARK: - Sorting
extension Portfolio {
    mutating func sortPositions() {
        self.positions.sort(by: > )
    }
}

//MARK: - Adding and removing positions to/from the portfolio
extension Portfolio {
    ///Adds a new position to the portfolio. Positions with negative quantity or price are dismissed and are not added.
    mutating func addNewPosition(companyName: String, numberOfShares: Int, openingPrice: Double) {
        
        guard numberOfShares > 0 && openingPrice > 0.0 else { return }
        
        if let existingPositionIndex = positions.firstIndex(where: { $0.companyName == companyName }) {
            positions[existingPositionIndex].addNewLot(numberOfShares: numberOfShares, openingPrice: openingPrice)
        } else {
            positions.append(.init(companyName: companyName, lots: [.init(numberOfShares: numberOfShares, openingPrice: openingPrice)]))
        }
        self.sortPositions()
        self.saveToLocalStorage()
    }
    
    mutating func removePositions(at indexSet: IndexSet) {
        positions.remove(atOffsets: indexSet)
        self.sortPositions()
        self.saveToLocalStorage()
    }
}

extension Portfolio {
    func allocationForADiversifiedPortfolio() {
        
    }
}

//
extension Portfolio {
    func saveToLocalStorage() {
        do { try PortfolioDataManager.savePortfolio(self) } catch { Logger.log(error: "Unable to save the portfolio because \(error.localizedDescription)") }
    }
}

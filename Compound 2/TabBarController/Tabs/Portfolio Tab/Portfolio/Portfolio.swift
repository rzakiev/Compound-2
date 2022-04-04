//
//  Portfolio.swift
//  Compound 2
//
//  Created by Robert Zakiev on 30.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct Portfolio: Codable {
    
    let positions: [Position]
    
    ///Default initializer
    init(positions: [Position]) {
        self.positions = positions
    }
    
    ///Use this initializer to laod a portfolio from local storage
    init?(fromLocalStorage: Bool) {
        guard let localPortfolio = PortfolioDataManager.getManuallyAddedLocalPortfolio() else { return nil }
        self = localPortfolio
    }
}

//MARK: - Dividends
extension Portfolio {
    @discardableResult
    func dividendFlow() -> Double {
        self.positions.compactMap(\.expectedDividend).reduce(0, +)
    }
}

//MARK: - Sorting
extension Portfolio {
    ///Sorts positions by the expected dividendFlow
//    mutating func sortPositions() {
//        self.positions.sort(by: > )
//    }
}

//MARK: - Adding and removing positions to/from the portfolio
extension Portfolio {
    ///Adds a new position to the portfolio. Positions with negative quantity or price are dismissed and are not added.
//    mutating func addNewPosition(companyName: String, numberOfShares: Int, openingPrice: Double) {
//
//        guard numberOfShares > 0 && openingPrice > 0.0 else {
//            Logger.log(error: "Attempting to add an invalid position: \(companyName) qty: \(numberOfShares); price: \(openingPrice)")
//            return
//        }
//
//        if let existingPositionIndex = positions.firstIndex(where: { $0.companyName == companyName }) {
//            positions[existingPositionIndex].addNewLot(numberOfShares: numberOfShares, openingPrice: openingPrice)
//        } else {
//            positions.append(.init(companyName: companyName, lots: [.init(numberOfShares: numberOfShares, openingPrice: openingPrice)]))
//        }
//        sortPositions()
//        saveToLocalStorage()
//        calculateGrossDividendFlow()
//    }
//
//    mutating func removePositions(at indexSet: IndexSet) {
//        positions.remove(atOffsets: indexSet)
//        sortPositions()
//        saveToLocalStorage()
//        calculateGrossDividendFlow()
//    }
}

//MARK: - Calculation of Position Ratios
extension Portfolio {
    func percentageOfTotalPortfolioForPosition(at index: Int) -> Double? {
        guard let expectedDividend = positions[index].expectedDividend else {
            return nil
        }
        
        return expectedDividend / 10
    }
}

//
extension Portfolio {
    func saveToLocalStorage() {
        do {
            try PortfolioDataManager.savePortfolio(self)
        } catch {
            Logger.log(error: "Unable to save the portfolio because: \(error.localizedDescription)")
        }
    }
}

extension Portfolio {
//    static func makeSamplePortfolio() -> Portfolio {
//
//        return .init(name: "Portfolio", positions: [Position(companyName: "Сбербанк", numberOfShares: 10, openingPrice: 20),
//                                                                                  .init(numberOfShares: 10, openingPrice: 30),
//                                                                                  .init(numberOfShares: 20, openingPrice: 50),
//                                                                                  .init(numberOfShares: 15, openingPrice: 34)]),
//                                                    Position(companyName: "Ростелеком", lots: [.init(numberOfShares: 10, openingPrice: 20)]),
//                                                    Position(companyName: "Ростелеком2", lots: [.init(numberOfShares: 10, openingPrice: 20)]),
//                                                    Position(companyName: "Ростелеком3", lots: [.init(numberOfShares: 10, openingPrice: 20)]),
//                                                    Position(companyName: "Ростелеком4", lots: [.init(numberOfShares: 10, openingPrice: 20)]),
//                                                    Position(companyName: "Ростелеком5", lots: [.init(numberOfShares: 10, openingPrice: 20)]),
//                                                    Position(companyName: "Ростелеком6", lots: [.init(numberOfShares: 10, openingPrice: 20)]),
//                                                    Position(companyName: "Газпром", lots: [.init(numberOfShares: 10, openingPrice: 20)])])
//    }
}

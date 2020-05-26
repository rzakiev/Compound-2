//
//  Position.swift
//  Compound 2
//
//  Created by Robert Zakiev on 30.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

struct Lot: Codable, Identifiable {
    
    var id = UUID()
    
    let numberOfShares: Int
    
    let openingPrice: Double
    
    var costBasis: Double {
        return Double (numberOfShares) * openingPrice
    }
    
    func profitAsPercentage(quote: Double) -> String {
        return numberWithSignAndPercentage(number: (quote - openingPrice) / openingPrice * 100)
    }
}

///Position in a specific security
struct Position: Codable, Identifiable {
    
    var id = UUID()
    
    let companyName: String //the name of the company in which the position hold
    
    var isPreferredShare: Bool { return companyName.suffix(2) == "-п" }
    
    var costBasis: Double {
        return lots.map({ $0.costBasis }).reduce(0, +)
    }
    
    private(set) var lots: [Lot]
    
    var numberOfShares: Int {
        return lots.map({ $0.numberOfShares }).reduce(0, +)
    }
    
    var averageOpeningPrice: Double {
        return lots.map({$0.openingPrice * Double($0.numberOfShares)}).reduce(0, +) / Double(numberOfShares)
    }
    
    var expectedDividend: Double? {
        return DividendCalculator.fixedDividend(for: self.companyName, numberOfShares: self.numberOfShares)
    }

//    let expectedDividend: Int? = 10
    
    
    
    
}
//MARK: - Initializers
extension Position {
    init(companyName: String, lots: [Lot]) {
        self.companyName = companyName
        self.lots = lots
    }
}

//MARK: - Managing Position Lots
extension Position {
    mutating func addNewLot(numberOfShares: Int, openingPrice: Double) {
        guard numberOfShares > 0 && openingPrice > 0.0 else { return }
        lots.append(.init(numberOfShares: numberOfShares, openingPrice: openingPrice))
    }
    
    mutating func removeLots(at indexSet: IndexSet) {
        lots.remove(atOffsets: indexSet)
        lots.sort(by: { $0.costBasis > $1.costBasis })
    }
}

//MARK: - Comparison
extension Position: Equatable, Comparable {
    static func < (lhs: Position, rhs: Position) -> Bool {
        
        if let lhsDividend = lhs.expectedDividend {
            if let rhsDividend = rhs.expectedDividend {
                return lhsDividend < rhsDividend
            } else {
                return false
            }
        } else {
            return true
        }
    }
    
    static func == (lhs: Position, rhs: Position) -> Bool {
        return lhs.companyName == rhs.companyName
    }
}

//Calculating profit or loss on the position
extension Position {
    
    ///Returne the profit or loss of the position expressed in percentage terms
    func profitAsPercentage(quote: Quote) -> Double? {
        let quoteAsDouble: Double
        if isPreferredShare {
            guard quote.preferredShareQuote != nil else { return nil }
            quoteAsDouble = quote.preferredShareQuote!
        } else {
            guard quote.ordinaryShareQuote != nil else { return nil }
            quoteAsDouble = quote.ordinaryShareQuote!
        }
        
        return (quoteAsDouble - averageOpeningPrice) / averageOpeningPrice * 100
    }
}

extension Position {
    
}

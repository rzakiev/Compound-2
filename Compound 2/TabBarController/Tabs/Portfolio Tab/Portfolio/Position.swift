//
//  Position.swift
//  Compound 2
//
//  Created by Robert Zakiev on 30.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

struct Lot: Codable, Hashable {

    let quantity: Int

    let openingPrice: Double

    var costBasis: Double { Double (quantity) * openingPrice }

    func profitAsPercentage(quote: Double) -> String {
        return numberWithSignAndPercentage(number: (quote - openingPrice) / openingPrice * 100)
    }
}

///Position in a specific security
struct Position: Hashable, Codable {
    
    let ticker: String
    
    var quantity: Int { lots.map(\.quantity).reduce(0, +) }
    
    let lots: [Lot]
    
    let currency: Currency
    
    var averageOpeningPrice: Double { lots.map(\.costBasis).reduce(0, +) / Double(quantity) }
    
    var expectedDividend: Double? {
        if let fixedDividend = DividendCalculator.fixedDividend(for: self.ticker, numberOfShares: self.quantity, adjustForDividendTax: false) { return fixedDividend }
        else if let localDividend = MoexDividendService.getLastYearDividend(for: self.ticker) { return localDividend * Double(self.quantity)}
        else { return nil }
    }
    
    var companyName: String? { C.Tickers.companyName(for: self.ticker) }
}
//MARK: - Initializers
extension Position {
    
    init(ticker: String, currency: String, lots: [Lot]) {
        self.ticker = ticker
        self.currency = Currency(fromString: currency)
        self.lots = lots
    }
    
    init(ticker: String, quantity: Int, averageOpeningPrice: Double, currency: String) {
        self.ticker = ticker
        self.currency = Currency(fromString: currency)
        self.lots = [Lot(quantity: quantity, openingPrice: averageOpeningPrice)]
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
        return lhs.ticker == rhs.ticker
    }
}

//Calculating profit or loss on the position
extension Position {
    
    ///Returne the profit or loss of the position expressed in percentage terms
    func profitAsPercentage(quote: SimpleQuote) -> Double? {
        
        let quoteAsDouble = quote.quote
        
        return (quoteAsDouble - averageOpeningPrice) / averageOpeningPrice * 100
    }
}

extension Position {
    func depositoryFeeForPosition() -> Double? {
        guard let depositoryFee = DepositoryReceiptFeeCalculator.fee(for: ticker) else {
            return nil
        }
        
        return Double(quantity) * depositoryFee.amount
    }
}

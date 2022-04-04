//
//  InvestmentIdea.swift
//  Compound 2
//
//  Created by Robert Zakiev on 02.04.2022.
//  Copyright © 2022 Robert Zakiev. All rights reserved.
//

import Foundation

//struct InvestmentIdeas: Codable {
//    let author: String
//    var values: [InvestmentIdea]
//    
//    
//    //MARK: - Initialization
//    init(author: String, values: [InvestmentIdea]) {
//        self.author = author
//        self.values = values
//    }
//}
//
//struct InvestmentIdea: Codable, Hashable {
//    
//    let authorName: String
//    
//    let ticker: String
//    
//    let currency: Currency
//    
//    let targetPrice: Double
//    
//    let priceOnOpening: Double?
//    
//    let openingDate: Date?
//    
//    let risk: String
//    
//    let companyName: String
//    
//    let investmentThesis: String?
//    
//    var upside: Double?
//   
//    ///Recalculates the current upside based on the new quote
//    mutating func updateUpside(currentQuote: SimpleQuote) {
//        guard currentQuote.quote > 0 else { return }
//        
//        let upside = (targetPrice - currentQuote.quote) / currentQuote.quote
//        
//        guard upside > 0 else {
//            return  //If it's greater than 0, the upside is realized
//        }
//        
//        self.upside = upside * 100
//    }
//}
//
//extension InvestmentIdea: Comparable {
//
//    static func < (lhs: InvestmentIdea, rhs: InvestmentIdea) -> Bool {
//        if lhs.upside == nil { return true }
//        else if rhs.upside == nil { return false }
//        else { return lhs.upside! < rhs.upside! }
//    }
//}

struct OldInvestmentIdeas: Codable {
    let author: String
    var values: [OldInvestmentIdea]
    
    
    //MARK: - Initialization
    init(author: String, values: [OldInvestmentIdea]) {
        self.author = author
        self.values = values
    }
}

struct OldInvestmentIdea: Codable, Hashable {
    
    let ticker: String
    
    let currency: Currency
    
    let targetPrice: Double
    
//    let priceOnOpening: Double?
    
//    let openingDate: Date?
    
    let risk: String
    
//    let companyName: String
    
//    let investmentThesis: String?
    
    var upside: Double?
   
    ///Recalculates the current upside based on the new quote
    mutating func updateUpside(currentQuote: SimpleQuote) {
        guard currentQuote.quote > 0 else { return }
        
        let upside = (targetPrice - currentQuote.quote) / currentQuote.quote
        
        guard upside > 0 else {
            return  //If it's greater than 0, the upside is realized
        }
        
        self.upside = upside * 100
    }
}


extension OldInvestmentIdea: Comparable {

    static func < (lhs: OldInvestmentIdea, rhs: OldInvestmentIdea) -> Bool {
        if lhs.upside == nil { return true }
        else if rhs.upside == nil { return false }
        else { return lhs.upside! < rhs.upside! }
    }
}

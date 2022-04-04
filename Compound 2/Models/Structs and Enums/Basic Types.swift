//
//  Basic Types.swift
//  Compound 2
//
//  Created by Robert Zakiev on 13.08.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

//MARK: - Financial Indicators
struct FinancialIndicators: Equatable {
    let revenue: [FinancialFigure]?
    let ebitda: [FinancialFigure]?
    let oibda: [FinancialFigure]?
    let netIncome: [FinancialFigure]?
    let freeCashFlow: [FinancialFigure]?
    let dividends: [FinancialFigure]?
    let netDebt: [FinancialFigure]?
    let numberOfOrdinaryShares: Int?
    let numberOfPreferredShares: Int?
    let dividendPolicy: String?
    let annualReports: [(year: Int, url: String)]?
    let presentations: [(year: Int, url: String)]?
    let competition: CompetitionType?
    let quoteURL: String?
    let customIndicators: [String: [FinancialFigure]]?
    
    public static func == (lhs: FinancialIndicators, rhs: FinancialIndicators) -> Bool {
        
        var equalityBooleans = [Bool]()
        for i in 0..<2 {
            
            guard rhs.revenue != nil && lhs.revenue != nil else { return false }
            
            if rhs.revenue![i].value == lhs.revenue![i].value {
                equalityBooleans.append(true)
            } else {
                equalityBooleans.append(false)
            }
        }
        
        return !equalityBooleans.contains(false) //if there are mismatches -- then not equal; if no mismatches -- equal
    }
}

//MARK: - Multipliers
public struct EVEBITDA: Identifiable {
    public var id = UUID()
    public let name: String
    public var evEBITDA: Double
}

public struct PriceToEarnings: Identifiable {
    public var id = UUID()
    public let ticker: String
    public let ratio: Double //name of the company for which the P/E ratio was calculated
}

//MARK: - Dividend Yield
public struct DividendYield: Identifiable {
    public var id = UUID()
    public let ticker: String
    public let yield: Double //name of the company for which the dividend yield was calculated
    public let isFixed: Bool
}

//MARK: - Quotes
//public struct Quote: Identifiable, CustomStringConvertible {
//    
//    public var description: String {
//        return "Company: \(companyName); Ordinary: \(String(describing: currentQuote)) ; Preferred: \(String(describing: preferredShareQuote))"
//    }
//    
//    public var id = UUID()
//    let companyName: String //name of the company for which the quote was fetched
//    let currentQuote: Double?
////    let preferredShareQuote: Double?
//}

public struct SimpleQuote: Identifiable, Hashable, CustomStringConvertible {
    
    public var description: String { "\(ticker): \(quote). Market cap: \(String(describing: marketCap))" }
    
    public var id = UUID()
    let ticker: String //name of the company for which the quote was fetched
    let quote: Double
    var companyName: String? { C.Tickers.companyName(for: self.ticker) }
    let marketCap: Double?
}

//MARK: - Statistics
struct CompanyWithCAGR: Identifiable {
    var id = UUID()
    let name: String
    let revenueCAGR: Double
}

struct IndustryWithCompaniesCAGR: Identifiable {
    var id = UUID()
    let name: String
    let companiesSortedByIndustryAndCAGR: [CompanyWithCAGR]
}

//MARK: - SwiftUI Extensions
struct IndexedCollection<Base: RandomAccessCollection>: RandomAccessCollection {
    typealias Index = Base.Index
    typealias Element = (index: Index, element: Base.Element)

    let base: Base

    var startIndex: Index { base.startIndex }

    var endIndex: Index { base.endIndex }

    func index(after i: Index) -> Index {
        base.index(after: i)
    }

    func index(before i: Index) -> Index {
        base.index(before: i)
    }

    func index(_ i: Index, offsetBy distance: Int) -> Index {
        base.index(i, offsetBy: distance)
    }

    subscript(position: Index) -> Element {
        (index: position, element: base[position])
    }
}

extension RandomAccessCollection {
    func indexed() -> IndexedCollection<Self> {
        IndexedCollection(base: self)
    }
}



struct QuoteData: Codable {
    let columns: [String]
    let data: [[Double]]
}

 // MARK: - MoexQuotes for parsing multiple quotes
 struct MoexQuotes: Codable {
     let marketdata: Marketdata
 }

 // MARK: - Marketdata
 struct Marketdata: Codable {
     let columns: [String]
     let data: [[SingleMoexQuote]]
 }

 enum SingleMoexQuote: Codable {
     case double(Double)
     case string(String)
     case null

     init(from decoder: Decoder) throws {
         let container = try decoder.singleValueContainer()
         if let x = try? container.decode(Double.self) {
             self = .double(x)
             return
         }
         if let x = try? container.decode(String.self) {
             self = .string(x)
             return
         }
         if container.decodeNil() {
             self = .null
             return
         }
         throw DecodingError.typeMismatch(SingleMoexQuote.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Datum"))
     }

     func encode(to encoder: Encoder) throws {
         var container = encoder.singleValueContainer()
         switch self {
         case .double(let x):
             try container.encode(x)
         case .string(let x):
             try container.encode(x)
         case .null:
             try container.encodeNil()
         }
     }
 }



//MARK: - Dividends
///Use this struct whenever a dividend is necessary
struct Dividends {
    let payouts: [Dividend]
}

struct Dividend: Codable {
    let payment: Double //the dividend payment itself
    let currency: Currency?
    let date: Double //UNIX timestamp
}


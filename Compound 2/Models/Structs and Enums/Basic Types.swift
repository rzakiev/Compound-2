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
    let revenue: [(year: Int, value: Double)]?
    let ebitda: [(year: Int, value: Double)]?
    let oibda: [(year: Int, value: Double)]?
    let netIncome: [(year: Int, value: Double)]?
    let freeCashFlow: [(year: Int, value: Double)]?
    let dividends: [(year: Int, value: Double)]?
    let netDebt: [(year: Int, value: Double)]?
    let numberOfOrdinaryShares: Int?
    let numberOfPreferredShares: Int?
    let dividendPolicy: String?
    let annualReports: [(year: Int, url: String)]?
    let presentations: [(year: Int, url: String)]?
    let competition: CompetitionType?
    let quoteURL: String?
    let customIndicators: [String: [(year: Int, value: Double)]]?
    
    static func == (lhs: FinancialIndicators, rhs: FinancialIndicators) -> Bool {
        
        var equalityBooleans = [Bool]()
        for i in 0..<2 {
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

struct EVEBITDA: Identifiable {
    var id = UUID()
    let name: String
    var evEBITDA: Double
}

struct PriceToEarnings: Identifiable {
    var id = UUID()
    let name: String
    let ratio: Double
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

//MARK: - Investments
struct InvestmentVerdict {
    let isGoodInvestment: Bool
    let analysis: String
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

//MARK: 

//
//  Aliases.swift
//  Compound 2
//
//  Created by Robert Zakiev on 12.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

//MARK: Type Aliases

struct ChartValue: Comparable {
    static func < (lhs: ChartValue, rhs: ChartValue) -> Bool {
        return lhs.value < rhs.value
    }
    
    let year: Int
    let value: Double
    let growth: Int?
}

struct FinancialFigure: Codable {
    let year: Int
    let value: Double
    let currency: Currency?
    
    init(year: Int, value: Double, currency: Currency? = nil) {
        self.year = year
        self.value = value
        self.currency = currency
    }
}

typealias CompaniesWithMultipliersAdjustedForCAGR = [(name: String, multiplier: Double, cagr: Double)]

typealias CompaniesWithMultipliersSortedByIndustry = [(industry: String, companies: CompaniesWithMultipliersAdjustedForCAGR)]

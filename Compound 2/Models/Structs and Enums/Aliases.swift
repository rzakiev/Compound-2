//
//  Aliases.swift
//  Compound 2
//
//  Created by Robert Zakiev on 12.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

//MARK: Type Aliases

struct ChartValueWithGrowth {
    let year: Int
    let value: Double
    let growth: Int?
}

typealias FinancialFigure = (year: Int, value: Double)

typealias CompaniesWithMultipliersAdjustedForCAGR = [(name: String, multiplier: Double, cagr: Double)]

typealias CompaniesWithMultipliersSortedByIndustry = [(industry: String, companies: CompaniesWithMultipliersAdjustedForCAGR)]

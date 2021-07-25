//////
//////  Statistics.swift
//////  Compound 2
//////
//////  Created by Robert Zakiev on 14.08.2019.
//////  Copyright © 2019 Robert Zakiev. All rights reserved.
//////
////
import Foundation

////MARK: - CAGR Calculation
struct Statistics {
    ///Calculates the CAGR using the starting sum, the resultant sum, and the number of years it took for growth to occur
    static func cagrFor(firstFigure: Double, lastFigure: Double, numberOfYearsInBetween: Int) -> Double {
        return pow(lastFigure / firstFigure, 1 / Double((numberOfYearsInBetween - 1))) - 1
    }
}
////
////Struct for calcualting various statistics
////MARK: - Sorting comapnies by various criteria
//struct Statistics {
//
//    ///This struct contains only static methods, no need to initialize anything
//    @available (*, unavailable)
//    fileprivate init() { Logger.log(error: "Initializing an instance of \(Self.self)") }
//
//    static func companiesSortedByRevenueCAGR() -> [(company: String, revenueCAGR: Double)] {
//
//        var revenueCAGRLastFiveYears = [(company: String, revenueCAGR: Double)]()
//
//        for company in C.Tickers.allTickerSymbols() {
//            let cagr = getRevenueCAGR(for: company)
//            revenueCAGRLastFiveYears.append((company, cagr))
//        }
//
//        revenueCAGRLastFiveYears.sort(by: {$0.revenueCAGR > $1.revenueCAGR})
//        return revenueCAGRLastFiveYears
//    }
//
//
//    static func companiesSortedByIndustryAndRevenueCAGR() -> [IndustryWithCompaniesCAGR] {
//
//        let companiesSortedByInustry = CorporateConstants.industries
//        let companiesSortedByCAGR = companiesSortedByRevenueCAGR()
//
//        var companiesSortedByIndustryAndRevenueCAGR = [IndustryWithCompaniesCAGR]()
//
//        for i in 0..<companiesSortedByInustry.count {
//
//            var companiesWithCagr = [CompanyWithCAGR]()
//
//            for company in companiesSortedByInustry[i].companies {
//                let cagr: Double = companiesSortedByCAGR.first(where: {$0.company == company})?.revenueCAGR ?? -1
//                companiesWithCagr.append(CompanyWithCAGR(name: company, revenueCAGR: cagr))
//            }
//
//            companiesWithCagr.sort(by: { $0.revenueCAGR > $1.revenueCAGR })
//
//            companiesSortedByIndustryAndRevenueCAGR.append(IndustryWithCompaniesCAGR(name: companiesSortedByInustry[i].name,
//                                                                                     companiesSortedByIndustryAndCAGR: companiesWithCagr))
//        }
//
//        return companiesSortedByIndustryAndRevenueCAGR
//    }
//}
//

//
////MARK: - Calculating growth rates for financial indicators
//extension Statistics {
//}

extension Statistics {
    
    static func grossGrowthRate(for company: String, for indicator: Indicator, numberOfYears: Int = 5) -> Int? {
        let company = Company(name: company)
        return company.grossGrowthRate(for: indicator, numberOfYears: numberOfYears)
    }
    
    static func grossGrowthRateForAllCompanies(for indicator: Indicator) -> [(company: String, grossGrowthRate: Int)] {
        let allCompanies = FinancialDataManager.listOfAllCompanies()
        
        var companiesWithTheirGrossGrowthRate = [(company: String, grossGrowthRate: Int)]()
        for company in allCompanies {
            if let grossGrowthRate = grossGrowthRate(for: company, for: indicator) {
                companiesWithTheirGrossGrowthRate.append((company, grossGrowthRate))
            }
        }
        
        
        return companiesWithTheirGrossGrowthRate.sorted(by: {$0.grossGrowthRate > $1.grossGrowthRate})
    }
}

//
//  Statistics.swift
//  Compound 2
//
//  Created by Robert Zakiev on 14.08.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

//Struct for calcualting various statistics
//MARK: - Sorting comapnies by various criteria
struct Statistics {
    
    static func companiesSortedByRevenueCAGR() -> [(company: String, revenueCAGR: Double)] {
        
        var revenueCAGRLastFiveYears = [(company: String, revenueCAGR: Double)]()
        
        for company in FinancialDataManager.listOfAllCompanies() {
            let cagr = getRevenueCAGR(for: company)
            revenueCAGRLastFiveYears.append((company, cagr))
        }
        
        revenueCAGRLastFiveYears.sort(by: {$0.revenueCAGR > $1.revenueCAGR})
        return revenueCAGRLastFiveYears
    }
    
    static func companiesSortedByIndustryAndRevenueCAGR() -> [IndustryWithCompaniesCAGR] {
        
        let companiesSortedByInustry = CorporateConstants.industries
        let companiesSortedByCAGR = companiesSortedByRevenueCAGR()
        
        var companiesSortedByIndustryAndRevenueCAGR = [IndustryWithCompaniesCAGR]()
        
        for i in 0..<companiesSortedByInustry.count {
            
            var companiesWithCagr = [CompanyWithCAGR]()
            
            for company in companiesSortedByInustry[i].companies {
                let cagr: Double = companiesSortedByCAGR.first(where: {$0.company == company})?.revenueCAGR ?? -1
                companiesWithCagr.append(CompanyWithCAGR(name: company, revenueCAGR: cagr))
            }
            
            companiesWithCagr.sort(by: { $0.revenueCAGR > $1.revenueCAGR })
            
            companiesSortedByIndustryAndRevenueCAGR.append(IndustryWithCompaniesCAGR(name: companiesSortedByInustry[i].name,
                                                                                     companiesSortedByIndustryAndCAGR: companiesWithCagr))
        }
        
        return companiesSortedByIndustryAndRevenueCAGR
    }
}

//MARK: - CAGR Calculation
extension Statistics {
    //simple utility function for calculating the CAGR for a specific period
    private static func cagrFor(firstFigure: Double, lastFigure: Double, numberOfYearsInBetween: Int) -> Double {
        return pow(lastFigure / firstFigure, 1 / Double((numberOfYearsInBetween - 1))) - 1
    }
    
    //calculating the compounded annual growth rate
    
    static func getRevenueCAGR(for company: String) -> Double {
        guard let revenue = FinancialDataManager.getRevenue(for: company) else {
            return -1
        }
        
        let revenueForLastFiveYears = Array(revenue.suffix(5))
        
        let firstYearRevenue = revenueForLastFiveYears[0].value
        let lastYearRevenue = revenueForLastFiveYears[revenueForLastFiveYears.count-1].value
        
        let cagr = cagrFor(firstFigure: firstYearRevenue, lastFigure: lastYearRevenue, numberOfYearsInBetween: revenueForLastFiveYears.count)
        return cagr
    }
}

//MARK: - Calculating growth rates for financial indicators
extension Statistics {
    
    static func grossGrowthRate(for company: String, for indicator: Indicator) -> Int? {
        let company = Company(name: company)
        return company.grossGrowthRate(for: indicator)
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

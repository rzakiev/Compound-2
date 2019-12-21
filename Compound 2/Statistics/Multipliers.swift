//
//  Multipliers.swift
//  Compound 2
//
//  Created by Robert Zakiev on 15.10.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

struct Multipliers {
    
    //EV/EBITDA
    public static func evEBITDAAdjustedForRevenueCAGR(for company: String) -> Double? {
        if let evEBITDA = evEBITDA(for: company) {
            let cagr = Statistics.getRevenueCAGR(for: company)
            return evEBITDA / cagr
        } else {
            return nil
        }
    }
    
    public static func evEBITDAForAllCompanies() -> [EVEBITDA] {
        guard let allPublicCompanies = try? FinancialDataManager.getSmartlabLinks().map({$0.key}) else {
            return []
        }
        return evEBITDAForMultipleCompanies(allPublicCompanies).map({ EVEBITDA(name: $0.company, evEBITDA: $0.evEBITDAAdjustedForCAGR) })
    }
    
    
    //P/E
    public static func priceToEarningsRatioForAllCompanies() -> [PriceToEarnings] {
        guard let allPublicCompanies = try? FinancialDataManager.getSmartlabLinks().map({$0.key}) else {
            Logger.log(error: "Unable to get the list of public companies")
            return []
        }
        
        return priceToEarningsForMultipleCompanies(allPublicCompanies)
    }
}

//MARK: - EV/EBITDA
extension Multipliers {
    
    static func evEBITDA(for company: String) -> Double? {
        
        if let operatingIncome = FinancialDataManager.getOperatingIncome(for: company)?.values.last?.value,
            let netDebt = FinancialDataManager.getNetDebt(for: company)?.last?.value,
            let marketCapitalization = QuoteService.shared.fetchMarketCapitalization(for: company) {
                return (marketCapitalization + netDebt * 1_000_000_000) / (operatingIncome * 1_000_000_000)
        }
        
        return nil
    }
    
    static func evEBITDAForMultipleCompanies(_ companies: [String]) -> [(company: String, evEBITDAAdjustedForCAGR: Double)] {
        
        var companiesCAGR = [(String, Double)]()
        for company in companies {
            if let evEBITDA = evEBITDA(for: company) {
                companiesCAGR.append((company, evEBITDA))
            }
        }
        return companiesCAGR.sorted(by: {$0.1 < $1.1})
    }
}

//MARK: - P/E
extension Multipliers {
    static func priceToEarnings(for company: String) -> Double? {
        
        guard let netIncome = FinancialDataManager.getNetIncome(for: company)?.last?.value else {
            return nil
        }
            
        guard netIncome > 0 else { //no need to calculate the P/E ratio for companies whose net income is negative or equal to 0
            return nil
        }
            
        guard let marketCapitalization = QuoteService.shared.fetchMarketCapitalization(for: company) else {
            return nil
        }
        
        return marketCapitalization / netIncome / 1_000_000_000
    }
    
    private static func priceToEarningsForMultipleCompanies(_ companies: [String]) -> [PriceToEarnings] {
        var peRatios = [PriceToEarnings]()
        for company in companies {
            if let peRatio = priceToEarnings(for: company) {
                peRatios.append(PriceToEarnings(name: company, ratio: peRatio))
            }
        }
        return peRatios.sorted(by: {$0.ratio < $1.ratio})
    }
}

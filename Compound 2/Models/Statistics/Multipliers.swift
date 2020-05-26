//
//  Multipliers.swift
//  Compound 2
//
//  Created by Robert Zakiev on 15.10.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

public struct Multipliers {
    
    @available (*, unavailable)
    init() {  }
    
    //EV/EBITDA
    public static func evEBITDAAdjustedForRevenueCAGR(for company: String) -> Double? {
        if let evEBITDA = evEBITDA(for: company) {
            let cagr = Statistics.getRevenueCAGR(for: company)
            return evEBITDA / cagr
        } else {
            return nil
        }
    }
    
    //Synchronously fetch price to earnings ratios for all companies
    public static func priceToEarningsRatioForAllCompanies() -> [PriceToEarnings] {
        guard let allPublicCompanies = try? FinancialDataManager.getSmartlabLinks().map({$0.key}) else {
            Logger.log(error: "Unable to get the list of public companies")
            return []
        }
        
        // TODO: Make an asynchronous version of this method
        
        return priceToEarningsForMultipleCompanies(allPublicCompanies)
    }
    
    //Asynchronously fetch price to earnings ratios for all companies
    public static func getPriceToEarningsRatioForAllCompaniesAsync(completion: @escaping ([PriceToEarnings]) -> Void) {
        DispatchQueue.main.async {
            let priceToEarningsRatios = priceToEarningsRatioForAllCompanies()
            completion(priceToEarningsRatios)
        }
    }
    
    public static func getPriceToEarningsRatios(with quotes: [SimpleQuote]) -> [PriceToEarnings] {
        
        var priceToEarningsRatios = [PriceToEarnings]()
        
        for quote in quotes {
            
            guard let companyName = quote.companyName else { continue }
            
            guard let companyData = try? FinancialDataManager.getCompanyData(for: companyName) else {
                Logger.log(error: "Multipliers: Unable to fetch company data for the company \(companyName)")
                continue
            }
            
            guard let profit = companyData.netIncome, profit.last!.value > 0 else { continue }
            
            guard let sharesCount = try? FinancialDataManager.numberOfSharesFor(company: companyName) else { continue }
            
            let marketCapitalization: Double = quote.quote * Double(sharesCount.numberOfOrdinaryShares)
            
            let priceToEarningsRatio = marketCapitalization / 1_000_000_000 / profit.last!.value
            
            priceToEarningsRatios.append(.init(name: companyName, ratio: priceToEarningsRatio))
        }
        
        return priceToEarningsRatios
    }
    
    public static func getPriceToEarningsRatio(with quote: SimpleQuote) -> PriceToEarnings? {
        return getPriceToEarningsRatios(with: [quote]).first
    }
    
    public static func priceToEarningsAdjustedForCAGR(for company: String, quote: SimpleQuote) -> Double? {
        let cagr = Statistics.getRevenueCAGR(for: company)
        guard let peRatio = getPriceToEarningsRatio(with: quote) else { print("Multipliers: Unable to get a PE ratio for \(quote.ticker)"); return nil }
        
        return peRatio.ratio / cagr / 100
    }
}

//MARK: - EV/EBITDA
public extension Multipliers {
    
    static func evEBITDA(for company: String) -> Double? {
        
        if let operatingIncome = FinancialDataManager.getOperatingIncome(for: company)?.values.last?.value,
            let netDebt = FinancialDataManager.getNetDebt(for: company)?.last?.value,
            let marketCapitalization = MarketCapitalization.calculateMarketCapitalization(for: company) {
            return (marketCapitalization + netDebt * 1_000_000_000) / (operatingIncome * 1_000_000_000)
        }
        return nil
    }
    
    static func evEBITDAAsync(for company: String, completion: @escaping (Double?) -> Void) {
        DispatchQueue.main.async {
            completion(evEBITDA(for: company))
        }
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
    
    static func evEBITDAForAllCompanies() -> [EVEBITDA] {
        guard let allPublicCompanies = try? FinancialDataManager.getSmartlabLinks().map({$0.key}) else {
            return []
        }
        return evEBITDAForMultipleCompanies(allPublicCompanies).map({ EVEBITDA(name: $0.company, evEBITDA: $0.evEBITDAAdjustedForCAGR) })
    }
}

//MARK: - P/E
extension Multipliers {
    ///Synchronously calculates the price-to-earnings ratio for a company
    static func priceToEarnings(for company: String) -> Double? {
        
        guard let netIncome = FinancialDataManager.getNetIncome(for: company)?.last?.value else {
            return nil
        }
        
        guard netIncome > 0 else { //no need to calculate the P/E ratio for companies whose net income is negative or equal to 0
            return nil
        }
        
        guard let marketCapitalization = MarketCapitalization.calculateMarketCapitalization(for: company) else {
            return nil
        }
        
        return marketCapitalization / netIncome / 1_000_000_000
    }
    
    static func priceToEarningsAsync(for company: String, completion: @escaping (Double?) -> Void) {
        DispatchQueue.main.async {
            completion(priceToEarnings(for: company))
        }
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

extension Multipliers {
    static func dividendYieldForAllCompanies(with quotes: [SimpleQuote]) -> [DividendYield] {
        
        guard quotes.count > 0 else { return [] }
        
        var dividends = [DividendYield]()
        
        for quote in quotes {
            guard let companyName = quote.companyName else { Logger.log(warning: "Not calculating the dividend yield for \(quote.ticker)"); continue }
            //In case we have a fixed dividend for the company
            if let fixedDividend = DividendCalculator.fixedDividendPerShare(for: quote.ticker) {
                
                let ordinaryShareYield = fixedDividend / quote.quote * 100
                dividends.append(.init(name: companyName, yield: ordinaryShareYield, isFixed: true))
                
                //In case we don't have a fixed dividend for the company
            } else {
                //Ordinary shares case
                guard let ordinaryShareDividends = FinancialDataManager.getDividends(for: companyName)?.last?.value
                    else { Logger.log(error: "No dividends for \(companyName)"); continue }
                
                let advancedQuote = Quote(companyName: companyName, ordinaryShareQuote: quote.quote, preferredShareQuote: nil)
                guard let ordinaryShareMarketCap = MarketCapitalization.calculateOrdinaryShareCapitalization(for: companyName, quote: advancedQuote) else { Logger.log(error: "Unable to calculate market cap for \(companyName)"); continue }
                
                let ordinaryShareYield = ordinaryShareDividends * 0.87  * 1_000_000_000 / ordinaryShareMarketCap * 100
                dividends.append(.init(name: companyName, yield: ordinaryShareYield, isFixed: false))
                
                
                
                
            }
        }
        
        return dividends
    }
}

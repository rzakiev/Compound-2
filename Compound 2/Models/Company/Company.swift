//
//  Company.swift
//  Compound 2
//
//  Created by Robert Zakiev on 25/08/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

struct Company {
    
    let name: String
    
    //Financial Indicators
    let revenue: [(year: Int, value: Double)]?
    
    let operatingIncome: [(year: Int, value: Double)]?
    let operatingIncomeType: OperatingIncomeType?
    
    let netIncome: [(year: Int, value: Double)]?
    let freeCashFlow: [(year: Int, value: Double)]?
    
    let dividends: [(year: Int, value: Double)]?
    
    private let netDebt: [(year: Int, value: Double)]? //Users shouldn't access net debt; rather, they should use the computed var debtToEBITDA
    
    let customIndicators: [String: [(year: Int, value: Double)]]? //Non-standard indicators like commission income, interest income, etc.
    
    let quoteLink: String?
    var isPublic: Bool {
        return quoteLink == nil ? false : true
    }
    
    let numberOfOrdinaryShares: Int?
    let numberOfPreferredShares: Int?
}

//MARK: - Initializers
extension Company {
     init(name: String) {
        //Loading the company's financial data from the company's respective plist file
        let companyPlistData = try! FinancialDataManager.getCompanyData(for: name)
        
        self.name = name
        
        revenue = companyPlistData.revenue ?? nil
        
        if let EBITDA = companyPlistData.ebitda {
            operatingIncome = EBITDA
            operatingIncomeType = .EBITDA
        } else if let OIBDA = companyPlistData.oibda {
            operatingIncome = OIBDA
            operatingIncomeType = .OIBDA
        } else {
            operatingIncome = nil
            operatingIncomeType = nil
        }
        netIncome = companyPlistData.netIncome ?? nil
        freeCashFlow = companyPlistData.freeCashFlow ?? nil
        dividends = companyPlistData.dividends ?? nil
        netDebt = companyPlistData.netDebt ?? nil
        customIndicators = companyPlistData.customIndicators ?? nil
        
        //assigning the smartlab quote links
        if let smartLabLinks = try? FinancialDataManager.getSmartlabLinks() {
            quoteLink = smartLabLinks[self.name]
            let shares = try? FinancialDataManager.numberOfSharesFor(company: name)
            (numberOfOrdinaryShares, numberOfPreferredShares) = (shares?.numberOfOrdinaryShares, shares?.numberOfPreferredShares)
        } else {
            quoteLink = nil
            (numberOfOrdinaryShares, numberOfPreferredShares) = (nil, nil)
        }
    }
}

//MARK: - Computed properties and methods for calculating various ratios
extension Company {
    var debtToEBITDA: [(year: Int, value: Double)]? {
        
        if let debt = netDebt, let ebitda = operatingIncome {
            var debtToEBITDA =  [(year: Int, value: Double)]()
            for i in 0..<ebitda.count {
                if ebitda[i].value != 0 {
                    debtToEBITDA.append((ebitda[i].year, debt[i].value / ebitda[i].value))
                }
            }
            return debtToEBITDA
        } else {
            return nil
        }
    }
    
}

//MARK: - Financial Indicators and Multipliers
extension Company {
    func availableIndicators() -> [Indicator] {
        var availableIndicators: [Indicator] = [] //all companies have revenue by default
        
        if revenue != nil { availableIndicators.append(.revenue) }
        
        if operatingIncome != nil {
            if operatingIncomeType! == .EBITDA {
                availableIndicators.append(.EBITDA)
            } else {
                availableIndicators.append(.OIBDA)
            }
        }
        
        if netIncome != nil { availableIndicators.append(.netProfit) }
        
        if freeCashFlow != nil { availableIndicators.append(.freeCashFlow) }
        
        if dividends != nil { availableIndicators.append(.dividend) }
        
        if debtToEBITDA != nil { availableIndicators.append(.debtToEBITDA) }
        
        if customIndicators != nil {
            for (indicator, _) in customIndicators! {
                switch indicator {
                case Indicator.commissionIncome.rawValue: availableIndicators.append(.commissionIncome)
                case Indicator.interestIncome.rawValue : availableIndicators.append(.interestIncome)
                default:
                    Logger.log(error: "Attempting to add a non-existent custom indicator: \(indicator)")
                }
            }
        }
                
        return availableIndicators
    }
    
    func values(for indicator: Indicator) -> [(year: Int, value: Double)]? {
        switch indicator {
        case .revenue:
            return revenue
        case .OIBDA, .EBITDA:
            if operatingIncome != nil { return operatingIncome }
            else { return nil}
        case .netProfit:
            if netIncome != nil { return netIncome }
            else { return nil }
        case .freeCashFlow:
            if freeCashFlow != nil { return freeCashFlow }
            else { return nil }
        case .dividend:
            if dividends != nil { return dividends }
            else { return nil }
        case .debtToEBITDA:
            if let debtToOperatingIncome = debtToEBITDA  { return debtToOperatingIncome }
            else { return nil }
        case .commissionIncome:
            if let commissionIncome = customIndicators?[Indicator.commissionIncome.rawValue] { return commissionIncome }
            else { return nil }
        case .interestIncome:
            if let interestIncome = customIndicators?[Indicator.interestIncome.rawValue] { return interestIncome }
            else { return nil }
        default:
            return nil
        }
    }
    
    func availableMultipliers() -> [Multiplier]? {
        if isPublic {
            var availableIndicators: [Multiplier] = [.priceToEarnings, .dividendYield]
            
            if operatingIncome != nil { availableIndicators.append(.EVtoEBITDA) }
            
            return availableIndicators
        } else {
            return nil
        }
    }
}

//MARK: - Growth indicators
extension Company {
    func growthRate (for indicator: Indicator) -> [(year: Int, value: Double, growth: Int?)]? {
        
        var growthRate = [(year: Int, value: Double, growth: Int?)]()
        
        //the financial indicator for which the growth rates are calculated
        let sourceIndicator: [(year: Int, value: Double)]
        switch indicator {
        case .revenue:
            if revenue == nil { return nil }
            else { sourceIndicator = revenue! }
        case .OIBDA, .EBITDA:
            if operatingIncome == nil { return nil }
            else { sourceIndicator = operatingIncome!}
        case .netProfit:
            if netIncome == nil { return nil }
            else { sourceIndicator = netIncome!}
        case .freeCashFlow:
            if freeCashFlow == nil { return nil }
            else { sourceIndicator = freeCashFlow! }
        case .dividend:
            if dividends == nil { return nil }
            else { sourceIndicator = dividends! }
        case .debtToEBITDA:
            if let debtToOperatingIncome = debtToEBITDA  { sourceIndicator = debtToOperatingIncome }
            else { return nil }
        case .interestIncome:
            if let interestIncome = customIndicators?[Indicator.interestIncome.rawValue] { sourceIndicator = interestIncome }
            else { return nil }
        case .commissionIncome:
            if let commissionIncome = customIndicators?[Indicator.commissionIncome.rawValue] { sourceIndicator = commissionIncome }
            else { return nil }
        default:
            return nil
        }
        
        growthRate.append((sourceIndicator[0].year, sourceIndicator[0].value, nil)) // the first chart does not have the growth indicator
        for i in 1..<sourceIndicator.count {
            
            let growth: Int?
            let numerator = sourceIndicator[i].value
            let denominator =  sourceIndicator[i-1].value
            
            if denominator == 0 { growth = nil } //cannot divide by 0; therefore -- nil
            else {
                growth = Int((numerator / denominator - 1) * 100)
            }
            
            growthRate.append((sourceIndicator[i].year, sourceIndicator[i].value, growth))
        }
        return growthRate
    }
    
    func grossGrowthRate (for indicator: Indicator) -> Int? {
        
        //the financial indicator for which the growth rates are calculated
        let sourceIndicator: [(year: Int, value: Double)]
        switch indicator {
        case .revenue:
            if revenue == nil { return nil }
            else { sourceIndicator = revenue! }
        case .OIBDA, .EBITDA:
            if operatingIncome == nil { return nil }
            else { sourceIndicator = operatingIncome!}
        case .netProfit:
            if netIncome == nil { return nil }
            else { sourceIndicator = netIncome!}
        case .freeCashFlow:
            if freeCashFlow == nil { return nil }
            else { sourceIndicator = freeCashFlow! }
        case .dividend:
            if dividends == nil { return nil }
            else { sourceIndicator = dividends! }
        case .debtToEBITDA:
            if let debtToOperatingIncome = debtToEBITDA  { sourceIndicator = debtToOperatingIncome }
            else { return nil }
        default:
            return nil
        }
        
        let firstNonNegativeFigure = sourceIndicator.first(where: {$0.value > 0})?.value
                   
        if firstNonNegativeFigure != nil {
            return Int((sourceIndicator[sourceIndicator.count-1].value / firstNonNegativeFigure! - 1) * 100)
        }
        else { return nil }
    }
    
//    func revenueGrowthRate() -> [(year: Int, growth: Double)] {
//        return Company.growthRate(figures: revenue)
//    }
}

//MARK: - Market Capitalization
extension Company {
    
    func fetchMarketCapitalization(completion: @escaping (Double) -> Void) {
        if isPublic {
            QuoteService.shared.asynchronouslyGetQuote(for: name) { (ordinaryQuote, preferredQuote) in
                
                if let ordinaryShares = self.numberOfOrdinaryShares, let ordinaryQuote = ordinaryQuote {
                    
                    //if the company has both ordinary and preferred shares
                    if let preferredShares = self.numberOfPreferredShares, let preferredQuote = preferredQuote {
                        let marketCap = Double(ordinaryShares) * ordinaryQuote + Double (preferredShares) * preferredQuote
                        completion(marketCap) //returing the fetched market cap back to the closure
                    } else { //If the company has only oridnary shares
                        let marketCap = Double(ordinaryShares) * ordinaryQuote //calculating the market capitalization
                        completion(marketCap) //returing the fetched market cap back to the closure
                    }
                }
            }
        }
    }
}

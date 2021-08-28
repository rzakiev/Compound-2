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
    let ticker: String
    
    //Financial Indicators
    let financialData: FinancialData
//    let revenue: [FinancialFigure]?
//
//    let operatingIncome: [FinancialFigure]?
//    let operatingIncomeType: OperatingIncomeType?
//
//    let netIncome: [FinancialFigure]?
//    let freeCashFlow: [FinancialFigure]?
//
//    let dividends: [FinancialFigure]?
//
//    let netDebt: [FinancialFigure]? //Don't use net debt; rather, use the computed var debtToEBITDA
//
//    let customIndicators: [String: [FinancialFigure]]? //Non-standard indicators like commission income, interest income, etc.
//
//    //    let quoteLink: String?
//    //    var isPublic: Bool { quoteLink != nil }
//
//    //    let numberOfOrdinaryShares: Int?
//    //    let numberOfPreferredShares: Int?
//
//    //Declaring a lazy property cointaining production figures
//    lazy var productionFigures = ProductionDataManager.getProductionFigures(for: name)
//
//    //Local Moex Dividends
//    var moexDividends: Dividend?
}

//MARK: - Initializers
extension Company {
    
    init(name: CompanyName) {
        
        self.name = name.name
        self.ticker = name.ticker
        
        if let smartLabData = SmartlabDataService.getLocalSmartlabData(for: [ticker]).first {
            financialData = smartLabData
        } else if let polygonData = PolygonDataService.getPolygonDataLocally(for: ticker) {
            financialData = polygonData
        } else {
            financialData = PolygonData(ticker: "N/A", values: [:])
        }
        
    }
    
//    init(name: String) {
//        //Loading the company's financial data from the company's respective plist file
//        guard let companyPlistData = try? FinancialDataManager.getCompanyData(for: name) else {
//            self.name = "No Data"
//            revenue = nil
//            operatingIncome = nil
//            operatingIncomeType = nil
//            netIncome = nil
//            freeCashFlow = nil
//            dividends = nil
//            netDebt = nil
//            customIndicators = nil
//            //            quoteLink = nil
//            //            numberOfOrdinaryShares = nil
//            //            numberOfPreferredShares = nil
//            return
//        }
//
//        self.name = name
//
//        revenue = companyPlistData.revenue ?? nil
//
//        if let EBITDA = companyPlistData.ebitda {
//            operatingIncome = EBITDA
//            operatingIncomeType = .EBITDA
//        } else if let OIBDA = companyPlistData.oibda {
//            operatingIncome = OIBDA
//            operatingIncomeType = .OIBDA
//        } else {
//            operatingIncome = nil
//            operatingIncomeType = nil
//        }
//
//        netIncome = companyPlistData.netIncome
//
//        freeCashFlow = companyPlistData.freeCashFlow
//
//        dividends = companyPlistData.dividends
//
//        netDebt = companyPlistData.netDebt ?? nil
//
//        customIndicators = companyPlistData.customIndicators ?? nil
//
//        //assigning the smartlab quote links
//        //        guard let smartLabLinks = try? FinancialDataManager.getSmartlabLinks(),
//        //              let quoteLink = smartLabLinks[self.name],
//        //              let shares = try? FinancialDataManager.numberOfSharesFor(ticker: name) else {
//        //
//        //                self.quoteLink = nil
//        //                (numberOfOrdinaryShares, numberOfPreferredShares) = (nil, nil)
//        //                return
//        //        }
//
//        //        self.quoteLink = quoteLink
//        //        (numberOfOrdinaryShares, numberOfPreferredShares) = (shares.numberOfOrdinaryShares, shares.numberOfPreferredShares)
//
//        guard let ticker = TickerSymbols.ticker(for: name) else { return }
//        self.moexDividends = MoexDataManager.getDividendDataLocally(forTicker: ticker)
//    }
}

//MARK: - Computed properties and methods for calculating various ratios
//extension Company {
//    var debtToEBITDA: [FinancialFigure]? {
//
//        if let debt = netDebt, let ebitda = operatingIncome {
//            var debtToEBITDA = [FinancialFigure]()
//            for i in 0..<ebitda.count {
//                if ebitda[i].value != 0 {
//                    debtToEBITDA.append(.init(year: ebitda[i].year, value: debt[i].value / ebitda[i].value))
//                }
//            }
//            return debtToEBITDA
//        } else {
//            return nil
//        }
//    }
//}

//MARK: - Financial Indicators
extension Company {
    func availableIndicators() -> [Indicator] {
        
        var availableIndicators: [Indicator] = []
        if financialData.getRevenue() != nil { availableIndicators.append(.revenue) }
        if financialData.getFCF() != nil { availableIndicators.append(.freeCashFlow) }
        if financialData.getDividend() != nil { availableIndicators.append(.dividend) }
        if financialData.getNetIncome() != nil { availableIndicators.append(.netIncome) }
        
        return availableIndicators
    }
}
//
//        if netIncome != nil { availableIndicators.append(.netProfit) }
//
//        if freeCashFlow != nil { availableIndicators.append(.freeCashFlow) }
//
//        if dividends != nil { availableIndicators.append(.dividend) }
//
//        if debtToEBITDA != nil { availableIndicators.append(.debtToEBITDA) }
//
//        if customIndicators != nil {
//            for (indicator, _) in customIndicators! {
//                switch indicator {
//                case Indicator.commissionIncome.title: availableIndicators.append(.commissionIncome)
//                case Indicator.interestIncome.title: availableIndicators.append(.interestIncome)
//                default:
//                    Logger.log(error: "Attempting to add a non-existent custom indicator: \(indicator)")
//                }
//            }
//        }
//
//        let indicatorsAdjustedForUserSettings = Preferences.requiredFinancialChartIndicators().filter({ availableIndicators.contains($0) })
//        return indicatorsAdjustedForUserSettings
//    }
//
//    //    func values(for indicator: Indicator) -> [(year: Int, value: Double)]? {
//    //        switch indicator {
//    //        case .revenue:
//    //            return revenue
//    //        case .OIBDA, .EBITDA:
//    //            if operatingIncome != nil { return operatingIncome }
//    //            else { return nil}
//    //        case .netProfit:
//    //            if netIncome != nil { return netIncome }
//    //            else { return nil }
//    //        case .freeCashFlow:
//    //            if freeCashFlow != nil { return freeCashFlow }
//    //            else { return nil }
//    //        case .dividend:
//    //            if dividends != nil { return dividends }
//    //            else { return nil }
//    //        case .debtToEBITDA:
//    //            if let debtToOperatingIncome = debtToEBITDA  { return debtToOperatingIncome }
//    //            else { return nil }
//    //        case .commissionIncome:
//    //            if let commissionIncome = customIndicators?[Indicator.commissionIncome.asString()] { return commissionIncome }
//    //            else { return nil }
//    //        case .interestIncome:
//    //            if let interestIncome = customIndicators?[Indicator.interestIncome.asString()] { return interestIncome }
//    //            else { return nil }
//    //        default:
//    //            return nil
//    //        }
//    //    }
//}

//MARK: -  Multipliers
//extension Company {
//    func availableMultipliers() -> [Multiplier]? {
//
//        var availableIndicators: [Multiplier] = [.priceToEarnings, .dividendYield]
//
//        if operatingIncome != nil { availableIndicators.append(.EVtoEBITDA) }
//
//        return availableIndicators
//    }
//    /// Synchronous request
//    //    func getpriceToEarningsRatioAsync(completion: @escaping (Double?) -> Void) {
//    //        DispatchQueue.main.async {
//    //            completion(Multipliers.priceToEarnings(for: self.name))
//    //        }
//    //    }
//    /// Synchronous request
//    //    func getEVEBITDA() -> Double? {
//    //        return Multipliers.evEBITDA(for: self.name)
//    //    }
//
//}

//MARK: - Growth indicators
extension Company {
    func chartValues (for indicator: Indicator) -> [ChartValue]? {
        
        var growthRate = [ChartValue]()
        
        //the financial indicator for which the growth rates are calculated
        let unwrapperIndicator: [FinancialFigure]?
        switch indicator {
        case .revenue: unwrapperIndicator = financialData.getRevenue()
        case .freeCashFlow: unwrapperIndicator = financialData.getFCF()
        case .dividend: unwrapperIndicator = financialData.getDividend()
        case .netIncome: unwrapperIndicator = financialData.getNetIncome()
        default:
            return nil
        }
        
        guard let sourceIndicator = unwrapperIndicator, sourceIndicator.count > 0 else { return nil }
        
        growthRate.append(.init(year: sourceIndicator[0].year, value: sourceIndicator[0].value, growth: nil)) // the first chart does not have the growth indicator
        for i in 1..<sourceIndicator.count {
            
            let growth: Int?
            let numerator = sourceIndicator[i].value
            let denominator =  sourceIndicator[i-1].value
            
            if denominator == 0 { growth = nil } //cannot divide by 0; therefore -- nil
            else {
                growth = Int((numerator / denominator - 1) * 100)
            }
            
            growthRate.append(.init(year: sourceIndicator[i].year, value: sourceIndicator[i].value, growth: growth))
        }
        return growthRate
    }
    
    func grossGrowthRate (for indicator: Indicator, numberOfYears: Int? = nil) -> Int? {

        //the financial indicator for which the growth rates are calculated
        let unwrapperIndicator: [FinancialFigure]?
        switch indicator {
        case .revenue: unwrapperIndicator = financialData.getRevenue()
        case .freeCashFlow: unwrapperIndicator = financialData.getFCF()
        case .dividend: unwrapperIndicator = financialData.getDividend()
        case .netIncome: unwrapperIndicator = financialData.getNetIncome()
        default:
            return nil
        }
        
        guard var sourceIndicator = unwrapperIndicator else { return nil }

        if numberOfYears != nil { sourceIndicator = sourceIndicator.suffix(numberOfYears!) }

        //        let numberOfValuesToDrop = ChartConstants.numberOfChartsAllowedOnThisDevice() > sourceIndicator.count ? 0 : sourceIndicator.count - ChartConstants.numberOfChartsAllowedOnThisDevice()
        //        sourceIndicator = Array(sourceIndicator.suffix(from: numberOfValuesToDrop))

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

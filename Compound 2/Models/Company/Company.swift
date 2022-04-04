//
//  Company.swift
//  Compound 2
//
//  Created by Robert Zakiev on 25/08/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import CoreData

struct Company {
    
    let name: String?
    let ticker: String
    
    //Financial Indicators
    let financialData: FinancialData
}

//MARK: - Initializers
extension Company {
    
    init(ticker: String, name: String? = nil) {
        
        self.name = name
        self.ticker = ticker
        
        if let smartLabData = SmartlabDataService.getLocalSmartlabData(for: [ticker]).first {
            financialData = smartLabData
        } else if let polygonData = PolygonDataService.getPolygonDataLocally(for: ticker) {
            financialData = polygonData
        } else {
            financialData = PolygonData(ticker: "N/A", values: [:])
        }
        
    }
}

extension Collection {
    var isNotEmpty: Bool { self.isEmpty == false }
}

//MARK: - Financial Indicators
extension Company {
    func availableIndicators() -> [Indicator] {
        
        var availableIndicators: [Indicator] = []
        
        if financialData.getRevenue() != nil && financialData.getRevenue()!.isNotEmpty {
            availableIndicators.append(.revenue)
        }
        
        if financialData.getFCF() != nil && financialData.getFCF()!.isNotEmpty == false {
            availableIndicators.append(.freeCashFlow)
        }
        if financialData.getDividend() != nil && financialData.getDividend()!.isNotEmpty == false  {
            availableIndicators.append(.dividend)
        }
        if financialData.getNetIncome() != nil && financialData.getNetIncome()!.isNotEmpty == false {
            availableIndicators.append(.netIncome)
        }
        
        return availableIndicators
    }
}

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

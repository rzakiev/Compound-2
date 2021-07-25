//
//  CompoundGrowthCalculator.swift
//  Compound 2
//
//  Created by Robert Zakiev on 15.05.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation

struct CompoundGrowthCalculator {
    @available (*, unavailable)
    fileprivate init() {  }
    
    static func compound(sum: Double, numberOfYears: Int, annualAdditionPercent: Int, principalGrowthPercent: Int) -> Double {
        var initialCapital = sum
        for _ in 0..<numberOfYears {
            initialCapital *= (1 + Double(principalGrowthPercent)/100) //Adjusting for organic growth
            initialCapital *= (1 + Double(annualAdditionPercent)/100) //Adjusting for dividend reinvestment
        }
        return initialCapital
    }
    
    static func compound(sum: Double, numberOfYears: Int, annualDeposit: Double = 0, principalGrowthPercent: Double) -> Double {
        var initialCapital = sum
        for _ in 0..<numberOfYears {
            initialCapital *= (1 + principalGrowthPercent/100)
            initialCapital += annualDeposit
        }
        return initialCapital
    }
    
    ///Compounds an initial capital over the specified number of years at the specified rate.
    ///
    ///- Parameter capital: The initial capital that will be compounded over the specified number of years.
    ///- Parameter numberOfYears: The number of years over which the capital will be compounded.
    ///- Parameter annualRate: The rate at which the capital will be compounded. Must be provided as a percentage. For example, if it's 20%, specify `20`
    static func compound (_ capital: Double, over numberOfYears: Int, at annualRate: Double) -> [ChartValue] {
        
        var capital = capital
        var year = Date.currentYear
        var chartValues: [ChartValue] = [.init(year: year, value: capital, growth: 0)]
        
        for _ in 0..<numberOfYears - 1 {
            capital *= (1 + annualRate/100)
            year = year + 1
            chartValues.append(.init(year: year, value: capital, growth: Int(annualRate)))
        }
        
        return chartValues
    }
}

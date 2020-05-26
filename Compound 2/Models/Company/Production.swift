//
//  Production.swift
//  Compound 2
//
//  Created by Robert Zakiev on 04.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

//This structure must be employed to contain production figures about a specific company
struct Production {
//    var id = UUID()
    let companyName: String
    
    let produce: [Produce]
}

struct Produce {
    var id = UUID()
    let name: String
    let unitOfMeasurement: String?
    let values: [(year: Int, value: Double)]
    
    func growthRateForChart() -> [ChartValueWithGrowth] {
        
        var chartValues = [ChartValueWithGrowth]()
        
        chartValues.append(.init(year: values[0].year, value: values[0].value, growth: nil)) // the first chart does not have the growth indicator
        for i in 1..<values.count {
            
            let growth: Int?
            let numerator = values[i].value
            let denominator =  values[i-1].value
            
            if denominator == 0 { growth = nil } //cannot divide by 0; therefore -- nil
            else {
                growth = Int((numerator / denominator - 1) * 100)
            }
            
            chartValues.append(.init(year: values[i].year, value: values[i].value, growth: growth))
        }
        return chartValues
    }
    
    func grossGrowthRate() -> Int? {
        let firstNonNegativeFigure = values.first(where: {$0.value > 0})?.value
                   
        if firstNonNegativeFigure != nil {
            return Int((values[values.count-1].value / firstNonNegativeFigure! - 1) * 100)
        }
        else { return nil }
    }
}

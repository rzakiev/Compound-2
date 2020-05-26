//
//  MacroConstants.swift
//  Compound 2
//
//  Created by Robert Zakiev on 02.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct ConstantsMacro {
    //MARK: - Inflation
    static let inflationRate = 4.0
    static let respectableGrowthRate = inflationRate * 3
    
    //MARK: - GDP
    ///in USD
    static let GDPOfWorld = 86_599_000_000_000.0
    ///in RUB
    static let GDPofRussia = 109_361_500_000_000.0
    
    //MARK: - Population
    static let worldPopulation = 7_756_122_300.0
    static let populationOfRussia = 145_920_611.0
    
    //MARK: - Interest Rates
    static let interestRateInRussia = 5.5
    static var interestRateYield: Double {
        100 / interestRateInRussia
    }
}

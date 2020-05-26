//
//  CompoundGrowthCalculator.swift
//  Compound 2
//
//  Created by Robert Zakiev on 09.02.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct CompoundGrowthCalculator {
    @available (*, unavailable)
    init() {  }
    
    static func compound(sum: Double, numberOfYears: Int, annualAdditionPercent: Int, principalGrowthPercent: Int) -> Double {
        var initialCapital = sum
        for _ in 0..<numberOfYears {
            initialCapital *= (1 + Double(principalGrowthPercent)/100)
            initialCapital *= (1 + Double(annualAdditionPercent)/100)
        }
        return initialCapital
    }
}

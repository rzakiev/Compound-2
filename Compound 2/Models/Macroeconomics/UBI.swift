//
//  UBI.swift
//  Compound 2
//
//  Created by Robert Zakiev on 02.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation


//Just thinking of a way to efficiently redistribute wealth in the global economy

struct UniversalBasicIncome {
    
    public static func monthlyPayoutInRussia(payoutRatio: Double) -> Double {
        let populationOfRussia = ConstantsMacro.populationOfRussia
        let gdpOfRussia = ConstantsMacro.GDPofRussia
        return calculateMonthlyPayoutPerPerson(sourceGDP: gdpOfRussia, percentageOfGDP: payoutRatio, population: populationOfRussia)
    }
    
    public static func monthlyPayoutInWorld(payoutRatio: Double) -> Double {
        let worldPopulation = ConstantsMacro.worldPopulation
        let gdpOfWorld = ConstantsMacro.GDPOfWorld
        return calculateMonthlyPayoutPerPerson(sourceGDP: gdpOfWorld, percentageOfGDP: payoutRatio, population: worldPopulation)
    }
}

extension UniversalBasicIncome {
    private static func calculateMonthlyPayoutPerPerson(sourceGDP: Double, percentageOfGDP: Double, population: Double) -> Double {
        
        guard sourceGDP > 0 && percentageOfGDP > 0 && population > 0 else { return 0 }
        
        let monthlyPayoutPerPerson = sourceGDP * percentageOfGDP / 100 / population / 12
        return monthlyPayoutPerPerson
    }
}

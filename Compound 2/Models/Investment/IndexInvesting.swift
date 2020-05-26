//
//  IndexInvesting.swift
//  Compound 2
//
//  Created by Robert Zakiev on 02.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

///This struct provides methods for calculating the amount of funds that investors must invest in securities from the MOEX index to mirror the index itself

struct IndexInvesting {
    
    @available (*, unavailable)
    init() {  } 
    
    ///Returns an array of companies and the corresponding amount of money that must be invested in said company in order to mirror the index
    static func investInIndex(amountOfFunds availableFunds: Double) -> [(company: String, moneyToInvestInCompany: Double)] {
        
        let companiesWithWeightInIndex = ConstantsIndex.weightedCompaniesOfMOEX
        
        var investmentsToMake = [(company: String, moneyToInvestInCompany: Double)]()
        for company in companiesWithWeightInIndex {
            let amountOfMoneyToInvest = company.weight / 100 * availableFunds
            investmentsToMake.append((company.name, amountOfMoneyToInvest))
        }
        
        return investmentsToMake.sorted(by: {$0.moneyToInvestInCompany > $1.moneyToInvestInCompany})
    }
}

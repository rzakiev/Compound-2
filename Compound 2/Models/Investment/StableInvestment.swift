//
//  StableInvestment.swift
//  Compound 2
//
//  Created by Robert Zakiev on 11.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct StableInvestmentCase: Investment {
    
    var company: String
    
    var cashFlowType: CashFlowType
    
    func checkInvestmentThesis() -> InvestmentVerdict {
        return .init(isGoodInvestment: false, analysis: "")
    }
    
    init?(company: String) {
        guard RiskAnalysis.companyIsCyclical(company) == false else {
            Logger.log(error: "Initializing a stable investment case with a company(\(company) that has variable cashflows")
            return nil
        }
        
        self.cashFlowType = .stable
        self.company = company
    }
    
    
}

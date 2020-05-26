//
//  InvestingProtocols.swift
//  Compound 2
//
//  Created by Robert Zakiev on 10.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

protocol Investment {
    
    var company: String { get }
    
    var cashFlowType: CashFlowType { get }
    
    func checkInvestmentThesis() -> InvestmentVerdict
}


//
//  DividendPolicyVerifier.swift
//  Compound 2
//
//  Created by Robert Zakiev on 25.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation


struct DividendPayout {
    let year: Int
    let didPayInFull: Bool
    let managementComment: String
}

struct DividendPolicyVerifier {
    
    @available(*, unavailable)
    init() {}
    
//    static func verifyDividendPayout(for company: String) -> [DividendPayout] {
//        var payoutHistory = [DividendPayout]()
//        guard var dividends = FinancialDataManager.getDividends(for: company) else { return [] }
//        guard var dividendPerShare =
//    }
}



extension DividendPolicyVerifier {
    private static let dividendPolicyEnactmentDate: [String: String] = [
           "AFKS" : "01/04/2017",
           "RTKM" : "14/03/2018",
           "RTKMP" : "14/03/2018",
    ]
}

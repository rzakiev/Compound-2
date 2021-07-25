//
//  NewPositionDataValidator.swift
//  Compound 2
//
//  Created by Robert Zakiev on 21.03.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct NewPositionDataValidator {
    
    static func numberOfSharesIsValid(for company: String, numberOfShares: String) -> (isValid: Bool, message: String?) {
        
        guard let numberOfSharesAsInt = Int(numberOfShares) else { return (false, "Неверный формат количества акций, введите целое число.") }
        
        guard numberOfSharesAsInt > 0 else { return (false, "Неверный формат количества акций, введите положительное число.") }
        
//        guard let sharesCount = try? FinancialDataManager.numberOfSharesFor(ticker: company) else { return (true, nil) }
        
//        if company.suffix(2) == "-п" { //case with preferred shares
//            if sharesCount.numberOfPreferredShares != nil { //preferred shares have been loaded from local storage
//                return sharesCount.numberOfPreferredShares! < numberOfSharesAsInt ? (false, "Слишком много акций.") : (true, nil)
//            } else {
//                Logger.log(error: "Unable to load the number of preferred shares from the local storage for \(company)")
//                return (true, nil) //no preferred shares locally; error!
//            }
//        } else {//case with ordinary shares
//            return sharesCount.numberOfOrdinaryShares < numberOfSharesAsInt ? (false, "Слишком много акций.") : (true, nil)
//        }
        return (true, nil)
    }
    
    static func costBasisIsValid(for company: String, costBasis: String) -> (isValid: Bool, message: String?) {
        guard let costBasisAsDouble = Double(costBasis) else { return (false, "Неверный формат цены, введите целое или дробное число.") }
        
        guard costBasisAsDouble > 0 else { return (false, "Неверный формат цены, введите положительное число.") }
        
        return (true, nil)
    }
}

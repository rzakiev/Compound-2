//
//  DepositoryReceiptFeeCalculator.swift
//  Compound 2
//
//  Created by Robert Zakiev on 08.11.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct DepositoryReceiptFeeCalculator {
    
    @available (*, unavailable)
    fileprivate init() {  }
    
    static func fee(for ticker: String) -> DepositoryFee? {
        guard let fee = depositoryReceiptFees[ticker] else {
            Logger.log(error: "no depository fee for \(ticker)")
            return nil
        }
        
        let parsedDate = parseFeeDueDateFromString(dateString: fee.date)
        
        return .init(ticker: ticker, amount: fee.amount, dueDate: parsedDate, yield: 0)
    }
    
    static func feeYieldsForAllDRs(quotes: [SimpleQuote], exchangeRate: Double) -> [DepositoryFee] {
        
        var yields = [DepositoryFee] ()
        for fee in depositoryReceiptFees {
            guard let quote = quotes.first(where: { $0.ticker == fee.key }) else {
                Logger.log(error: "No quote to calculate DR fee for \(fee.key)")
                continue
            }
            
            let parsedDate = parseFeeDueDateFromString(dateString: fee.value.date)
            
            let yield = fee.value.amount * exchangeRate / quote.quote * 100
            yields.append(.init(ticker: fee.key, amount: fee.value.amount, dueDate: parsedDate, yield: yield))
        }
        return yields.sorted(by: > )
    }
}

//MARK: - Fees
extension DepositoryReceiptFeeCalculator {
    private static let depositoryReceiptFees: [String : (amount: Double, date: String)] = [
        "ETLN" : (0.03, "6/11"),
        "GLTR" : (0.02, "6/11"),
        "MAIL" : (0.0075, "15/10"),
        "FIVE" : (0.03, "02/01"),
        "LNTA" : (0.03, "20/04"),
        "AGRO" : (0.03, "06/05"),
        "TCSG" : (0.02, "31/08"),
        "QIWI" : (0.03, "03/05"),
        "HHRU" : (0.03, "02/11"),
        "OZON" : (0.03, "30/12"),
        //WARNING: Add these commissions!
//        "OKEY" : ()
//        "MDMG" : ()
    ]
}

//MARK: - Utilities
extension DepositoryReceiptFeeCalculator {
    private static func parseFeeDueDateFromString(dateString: String) -> String? {
        
        let splitDate = dateString.split(separator: "/")
        guard splitDate.count >= 2 else { return nil }
        
        let month: String
        switch splitDate[1] {
        case "01": month = " января"
        case "02": month = " февраля"
        case "03": month = " марта"
        case "04": month = " апреля"
        case "05": month = " мая"
        case "06": month = " июня"
        case "07": month = " июля"
        case "08": month = " августа"
        case "09": month = " сентября"
        case "10": month = " октября"
        case "11": month = " ноября"
        case "12": month = " декабря"
        default:
            month = ""
        }
        
        return splitDate[0] + month
    }
}

struct DepositoryFee: Identifiable, Comparable {
    
    var id = UUID()
    let ticker: String
    let amount: Double
    let currency: Currency = .USD
    let dueDate: String?
    let yield: Double
    
    static func < (lhs: DepositoryFee, rhs: DepositoryFee) -> Bool {
        return lhs.yield < rhs.yield
    }
}

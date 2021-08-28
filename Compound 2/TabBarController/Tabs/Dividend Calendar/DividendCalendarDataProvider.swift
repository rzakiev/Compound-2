//
//  DividendCalendarDataProvider.swift
//  Compound 2
//
//  Created by Robert Zakiev on 14.11.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation
import Combine

struct DividendPayment: Identifiable {
    
    var id = UUID()
    
    let ticker: String
    let amount: Double
    let paymentDate: Date
    
    var yield: Double = 0
    
    var name: String? { C.Tickers.companyName(for: ticker) }
    
    static func < (lhs: DividendPayment, rhs: DividendPayment) -> Bool {
        return lhs.paymentDate < rhs.paymentDate
    }
}

final class DividendCalendarDataProvider: ObservableObject {
    
    @Published var dividendPayments: [DividendPayment] = []
    
    private var quoteSubscriber: AnyCancellable?
    
    init() {
        let localDividends = MoexDataManager.getDividendDataLocallyForAllCompanies()
        dividendPayments = DividendCalendarDataProvider.filterFutureDividendPayments(dividends: localDividends)
        
        quoteSubscriber = MoexQuoteService.shared.$allQuotes.receive(on: DispatchQueue.main).sink(receiveValue: { [unowned self] _ in
            self.calculateYields()
        })
    }
}

extension DividendCalendarDataProvider {
    static func filterFutureDividendPayments(dividends: [MoexDividend]) -> [DividendPayment] {
        
        var payments = [DividendPayment]()
        
        for dividend in dividends {
            for payment in dividend.dividends ?? [] {
                guard let parsedDate =  payment.registryclosedate.asDate() else {
                    Logger.log(error: "unable to decode dividend payment date \(payment.registryclosedate)")
                    continue
                }
                if parsedDate > Date() {
                    Logger.log(operation: "parsed date(\(parsedDate) is in the future!!! \(payment.secid) \(payment.value)")
                    payments.append(.init(ticker: payment.secid, amount: payment.value, paymentDate: parsedDate))
                } else {
                    Logger.log(operation: "parsed date(\(parsedDate) is earlier than now (\(Date())")
                }
            }
        }
        
        return payments.sorted(by: <)
    }
    
    func calculateYields() {
        for i in 0..<dividendPayments.count {
            guard let currentQuote = MoexQuoteService.shared.quote(for: dividendPayments[i].ticker) else {
                continue
            }
            dividendPayments[i].yield = dividendPayments[i].amount / currentQuote.quote * 100
        }
    }
}



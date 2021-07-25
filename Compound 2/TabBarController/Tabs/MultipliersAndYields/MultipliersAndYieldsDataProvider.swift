//
//  MultipliersAndYieldsDataProvider.swift
//  Compound 2
//
//  Created by Robert Zakiev on 31.12.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//


import SwiftUI
import Combine

///Provides data for the MultipliersAndYieldsView —  including the price-to-earnings ratio for all companies. This struct also contains methods that adjust the multipliers for the revenue growth
final class MultipliersAndYieldsDataProvider: ObservableObject {
    
    @Published var dividendYields: (fixedDividends: [DividendYield], variableDividends: [DividendYield]) = ([],[])
    
    private var quoteSubscriber: AnyCancellable?
    
    init() {
        quoteSubscriber = MoexQuoteService.shared.$allQuotes.receive(on: DispatchQueue.main).sink(receiveValue: { [unowned self] _ in
            self.updateMultipliersOnceQuotesAreReceived()
        })
    }
//    @Published var listData = [(String, Double)]()
}

//MARK: - Adjusting multipliers and yields based on the user's preferences
private extension MultipliersAndYieldsDataProvider {
//    private func adjustMultipliersForCAGR() -> [PriceToEarnings] {
//        var adjustedMultipliers: [PriceToEarnings] = []
//        (priceToEarningsRatioForAllCompanies.map({ ($0.ticker, $0.ratio) })).forEach { [unowned self] multiplier in
//            guard let cagr = self.companiesSortedByCAGR.first(where: {$0.company == multiplier.0})?.revenueCAGR else { return }
//            adjustedMultipliers.append(.init(ticker: multiplier.0, ratio: multiplier.1 / cagr / 100))
//        }
//        return adjustedMultipliers.sorted(by: { $0.ratio < $1.ratio} )
//    }
}

//MARK: - Fetching Multipliers
extension MultipliersAndYieldsDataProvider {
    private func updateMultipliersOnceQuotesAreReceived() {
        
        let dividends = MoexDividendService.dividendYieldForAllCompanies(with: MoexQuoteService.shared.allQuotes).sorted(by: { $0.yield > $1.yield })
        
        let fixedDividends = dividends.filter({ $0.isFixed })
        let variableDividends = dividends.filter({ !$0.isFixed })
        
        self.dividendYields = (fixedDividends, variableDividends)
    }
}

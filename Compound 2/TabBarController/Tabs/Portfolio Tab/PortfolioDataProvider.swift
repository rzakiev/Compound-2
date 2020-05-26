//
//  PortfolioDataProvider.swift
//  Compound 2
//
//  Created by Robert Zakiev on 20.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation
import Combine

final class PortfolioDataProvider: ObservableObject {
    
    @Published var portfolio: Portfolio = Portfolio(fromLocalStorage: true) ?? Portfolio(name: "Портфолио", positions: [])
    
    private var quoteSubscriber: AnyCancellable?
    
    var myQuotes: [Quote] = []
    
    init() {
//        QuoteService.generateFakeQuotes()
      
        quoteSubscriber = QuoteService.shared.$allQuotes.receive(on: DispatchQueue.main).sink(receiveValue: { [unowned self] (quotes) in
            for i in 0..<self.portfolio.positions.count {
                guard let _ = quotes.first(where: { $0.companyName == self.portfolio.positions[i].companyName || $0.companyName == self.portfolio.positions[i].companyName + "-п" }) else { continue }
                if self.portfolio.positions[i].isPreferredShare {
//                    self.portfolio.positions[i].updatePL(quote: newQuote.preferredShareQuote ?? 0.0)
                } else {
//                    self.portfolio.positions[i].updatePL(quote: newQuote.ordinaryShareQuote ?? 0.0)
                }
            }
        })
    }
    
}

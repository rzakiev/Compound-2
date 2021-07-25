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
    
    @Published var portfolio: Portfolio = Portfolio(fromLocalStorage: true) ?? Portfolio(positions: [])
    
    private var quoteSubscriber: AnyCancellable?
    
    init() {
        quoteSubscriber = MoexQuoteService.shared.$allQuotes.receive(on: DispatchQueue.main).sink(receiveValue: { [unowned self] (_) in
            for i in 0..<self.portfolio.positions.count {
                guard let _ = MoexQuoteService.shared.allQuotes.first(where: { $0.ticker == self.portfolio.positions[i].ticker }) else { continue }
            }
        })
    }
}

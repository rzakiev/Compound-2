//
//  PortfolioReturnTableView.swift
//  PortfolioReturnTableView
//
//  Created by Robert Zakiev on 25.07.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct PortfolioReturnTableView: View {
    
    let portfolioReturns: PortfolioReturns
    
    var body: some View {
        List {
            ForEach(0..<portfolioReturns.values.count, id:\.self) { index in
                HStack {
                    Text(String(portfolioReturns.values[index].year))
                    Text(String(portfolioReturns.values[index].accountValueAtStartOfYear))
                    if portfolioReturns.values[safe: index + 1] != nil {
                        Text(String(specificYearReturn(index: index)))
                    }
                }
            }
        }
    }
    
    func specificYearReturn(index: Int) -> Double {
        return portfolioReturns.values[index].yearReturn(accountValueAtEndOfYear: portfolioReturns.values[index + 1].accountValueAtStartOfYear)
    }
    
    init(returns: PortfolioReturns) {
        self.portfolioReturns = returns
    }
}

struct PortfolioReturnTableView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioReturnTableView(returns: PortfolioReturnCalculator.loadPortfolioReturns().first!)
    }
}

//
//  PortfolioReturnsView.swift
//  PortfolioReturnsView
//
//  Created by Robert Zakiev on 25.07.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct PortfolioReturnsView: View {
    
    let portfolioReturns: [PortfolioReturns]
    
    var body: some View {
        ForEach(0..<portfolioReturns.count, id:\.self) { index in
            PortfolioReturnTableView(returns: portfolioReturns[index])
        }
    }
    
    init() {
        portfolioReturns = PortfolioReturnCalculator.loadPortfolioReturns()
    }
}

struct PortfolioReturnsView_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioReturnsView()
    }
}

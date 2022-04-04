//
//  CompanyMultipliersView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 21.11.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import SwiftUI
import Combine

struct CompanyMultipliersView: View {
    
    let ticker: String
    
    @EnvironmentObject var dataProvider: ChartListDataProvider
    
    let multipliers: [Multiplier] = Multiplier.allCases
    
    @State var marketCap: Double?
    
    @State var priceToEarnings: Double?
    
    init(ticker: String) {
        self.ticker = ticker
    }
    
    var body: some View {
        List {
            ForEach(multipliers, id: \.self) { multiplier in
                HStack {
                    Text(multiplier.title)
                    Spacer()
                    Text(text(for: multiplier))
                }
            }
        }
    }
    
    
}

extension CompanyMultipliersView {
    func text(for multiplier: Multiplier) -> String {
        switch multiplier {
        case .priceToEarnings: return priceToEarningsText()
        case .priceToSales: return priceToSalesText()
        case .dividendYield: return dividendYieldText()
        }
    }
    
    func priceToEarningsText() -> String {
        let priceToEarnings = Multipliers.priceToEarnings(for: ticker, quote: dataProvider.quote, netIncome: dataProvider.financialFigures?.financialData.getLastYearNetIncome()) ?? 0
        
        return String(priceToEarnings)
    }
    
    func priceToSalesText() -> String {
        let priceToSales = Multipliers.priceToSales(for: ticker, quote: dataProvider.quote, revenue: dataProvider.financialFigures?.financialData.getRevenue()?.last?.value) ?? 0
        
        return String(priceToSales)
    }
    
    func dividendYieldText() -> String {
        let dividendYield = Multipliers.dividendYield(for: ticker, quote: dataProvider.quote, dividend: dataProvider.financialFigures?.financialData.getDividend()?.last?.value) ?? 0
        
        return String(dividendYield) + "%"
    }
}


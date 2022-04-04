//
//  IdeasUpsideView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 10.05.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct IdeasUpsideView: View {
    
    @ObservedObject var investments: IdeasUpsideDataProvider
    
    @State private var selectedTab = "USA"
    
    init(fileName: (name: String, format: String)) {
        self.investments = IdeasUpsideDataProvider(fileName: fileName)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            Divider()
            Picker(selection: $selectedTab, label: Text("Does this work?")) {
                Text("USA").tag("USA")
                Text("РФ").tag("РФ")
            }.frame(maxWidth: 200)
                .pickerStyle(SegmentedPickerStyle())
            
            currentDateView
            
            if selectedTab == "USA" { americanStocksUpsideView }
            else { russianStocksUpsideView }
            
            Divider()
        }
    }
}

extension IdeasUpsideView {
    var currentDateView: some View {
        Text(Date.beautifulCurrentDate())
            .font(.system(size: 30, weight: .bold, design: .rounded))
            .bold()
            .padding([.top], 20)
    }
    
    var americanStocksUpsideView: some View {
        VStack {
            if investments.ideas.values.filter({ $0.risk == "low" && $0.currency == .USD }).count != 0 {
                IdeasUpsideChart(chartValues: lowRiskAmericanStocks).frame(minWidth: 0, maxWidth: .infinity, minHeight: 500)
            }
            IdeasUpsideChart(chartValues: mediumRiskAmericanStocks).frame(minWidth: 0, maxWidth: .infinity,  minHeight: 500)
            IdeasUpsideChart(chartValues: highRiskAmericanStocks).frame(minWidth: 0, maxWidth: .infinity,  minHeight: 500)
        }
    }
    
    
    var russianStocksUpsideView: some View {
        return IdeasUpsideChart(chartValues: investments.ideas.values.filter({ $0.currency == .Rouble }).sorted(by: > ).map({
            IdeasUpsideChart.UpsideChartValue(ticker: $0.ticker, targetPrice: $0.targetPrice, upside: ($0.upside ?? 0), currency: $0.currency, risk: $0.risk)
        })).frame(minHeight: 500)
    }
}

extension IdeasUpsideView {
    var lowRiskAmericanStocks: [IdeasUpsideChart.UpsideChartValue] {
        return investments.ideas.values.filter({ $0.currency == .USD && $0.risk == "low" }).sorted(by: > ).map({
            IdeasUpsideChart.UpsideChartValue(ticker: $0.ticker, targetPrice: $0.targetPrice, upside: ($0.upside ?? 0), currency: $0.currency, risk: $0.risk)
        })
    }
    
    var mediumRiskAmericanStocks: [IdeasUpsideChart.UpsideChartValue] {
        return investments.ideas.values.filter({ $0.currency == .USD && $0.risk == "medium" }).sorted(by: > ).map({
            IdeasUpsideChart.UpsideChartValue(ticker: $0.ticker, targetPrice: $0.targetPrice, upside: ($0.upside ?? 0), currency: $0.currency, risk: $0.risk)
        })
    }
    
    var highRiskAmericanStocks: [IdeasUpsideChart.UpsideChartValue] {
        return investments.ideas.values.filter({ $0.currency == .USD && $0.risk == "high" }).sorted(by: > ).map({
            IdeasUpsideChart.UpsideChartValue(ticker: $0.ticker, targetPrice: $0.targetPrice, upside: ($0.upside ?? 0), currency: $0.currency, risk: $0.risk)
        })
    }
}

//
//  SegmentedCompanyInfoView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 08.12.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

struct SegmentedCompanyInfoView: View {
    
    let company: CompanyName
    @StateObject var companyData: ChartListDataProvider
    
    @State private var selectedSegment = 0
    
    private let segments: [CompanyInfoSegment]
    
    init(company: CompanyName) {
        self.company = company
        self.segments = Preferences.requiredSegmentsInSegmentedCompanyView(for: company.ticker)
        _companyData = StateObject(wrappedValue: ChartListDataProvider(ticker: company.ticker))
    }
    
    var body: some View {
        return VStack {
            HStack {
                financialChartListView//.border(Color.green)
                multipliersView//.border(Color.green)
            }
            tradingViewChart
        }
        .navigationBarTitle(Text(company.name), displayMode: .large)
    }
}

extension SegmentedCompanyInfoView {
    var financialChartListView: some View {
        FinancialChartList(company: company)
            .environmentObject(companyData)
    }
    
    var multipliersView: some View {
        CompanyMultipliersView(ticker: company.ticker)
            .environmentObject(companyData)
    }
    
    var tradingViewChart: some View {
        TradingViewChart(ticker: company.ticker)
    }
}


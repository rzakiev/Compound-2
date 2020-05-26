//
//  StatisticsView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 05/09/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

struct StatisticsTab: View {
    
    @State private var selectedTab: String = "revenue"
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Picker(selection: $selectedTab, label: Text("")) {
                    Text("Revenue").tag("revenue")
                    Text("Profit").tag("profit")
                    Text("Dividends").tag("dividends")
                }.pickerStyle(SegmentedPickerStyle())
                
                if selectedTab == "revenue" {
                    GrossRevenueGrowthView()
                } else if selectedTab == "profit" {
                    GrossProfitGrowthView()
                } else {
                    DividendGrowthForAllCompaniesView()
                }
                Spacer()
            }.navigationBarTitle("Статистика", displayMode: .inline)
        }
    }
}

#if DEBUG
struct StatisticsTabPreview: PreviewProvider {
    static var previews: some View {
        StatisticsTab()
    }
}
#endif

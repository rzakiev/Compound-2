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
    
    @State var selectedTab: Int = 0
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Picker(selection: $selectedTab, label: Text("")) {
                    Text("Revenue").tag(0)
                    Text("Profit").tag(1)
                    Text("Dividends").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                //                .frame(alignment: .trailing)
                //                .background(Color.green)
                if selectedTab == 0 {
                    GrossRevenueGrowthView()
                } else if selectedTab == 1 {
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

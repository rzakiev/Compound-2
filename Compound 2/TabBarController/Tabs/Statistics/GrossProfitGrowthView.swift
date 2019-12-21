//
//  GrossProfitGrowthView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 20.10.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct GrossProfitGrowthView: View {
    let companiesAndTheirGrossProfitGrowth = Statistics.grossGrowthRateForAllCompanies(for: .netProfit)
       
       var body: some View {
           List(Array(companiesAndTheirGrossProfitGrowth.indices), id:\.self) { index in
               HStack {
                   Text(self.companiesAndTheirGrossProfitGrowth[index].company)
                   Spacer()
                   Text(String.beautifulGrossGrowthRateString(from: self.companiesAndTheirGrossProfitGrowth[index].grossGrowthRate))
               }
           }
       }
    
    init() {
        print("Initializing gross profit view")
    }
}

#if DEBUG
struct GrossProfitGrowthView_Previews: PreviewProvider {
    static var previews: some View {
        GrossProfitGrowthView()
    }
}
#endif

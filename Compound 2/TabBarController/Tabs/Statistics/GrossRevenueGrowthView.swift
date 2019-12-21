//
//  GrossRevenueGrowthView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 20.10.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

struct GrossRevenueGrowthView: View {
    let companiesAndTheirGrossDividendGrowth = Statistics.grossGrowthRateForAllCompanies(for: .revenue)
    
    var body: some View {
        List(Array(companiesAndTheirGrossDividendGrowth.indices), id:\.self) { index in
            HStack {
                Text(self.companiesAndTheirGrossDividendGrowth[index].company)
                Spacer()
                Text(String.beautifulGrossGrowthRateString(from: self.companiesAndTheirGrossDividendGrowth[index].grossGrowthRate))
            }
        }
    }
    
    init() {
        print("Initializing gross revenue view")
    }
}

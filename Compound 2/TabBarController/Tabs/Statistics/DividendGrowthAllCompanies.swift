////
////  DividendGrowthAllCompanies.swift
////  Compound 2
////
////  Created by Robert Zakiev on 18.10.2019.
////  Copyright © 2019 Robert Zakiev. All rights reserved.
////
//
//import Foundation
//import SwiftUI
//
//
//struct DividendGrowthForAllCompaniesView: View {
//    
//    let companiesAndTheirGrossDividendGrowth = Statistics.grossGrowthRateForAllCompanies(for: .dividend)
//    
//    var body: some View {
//        List(Array(companiesAndTheirGrossDividendGrowth.indices), id:\.self) { index in
//            HStack {
//                Text(self.companiesAndTheirGrossDividendGrowth[index].company)
//                Spacer()
//                Text(String.beautifulGrossGrowthRateString(from: self.companiesAndTheirGrossDividendGrowth[index].grossGrowthRate))
//            }
//        }
//    }
//    
//    init() {
//        print("Initializing gross dividend view")
//    }
//}
//
//#if DEBUG
//struct DividendGrowthForAllCompaniesListPreview: PreviewProvider {
//    static var previews: some View {
//        DividendGrowthForAllCompaniesView()
//    }
//}
//#endif

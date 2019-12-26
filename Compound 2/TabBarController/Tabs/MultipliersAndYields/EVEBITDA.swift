//
//  EV:EBITDA.swift
//  Compound 2
//
//  Created by Robert Zakiev on 14.10.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI



struct EV_EBITDA: View {
    
    private let revenueCAGRforAllCompanies = Statistics.companiesSortedByRevenueCAGR()
    
    private let priceToEarningsRatioForAllCompanies = Multipliers.priceToEarningsRatioForAllCompanies()
    
    @State var tableData = [(company: String, multiplier: Double)]()
    
    @State var adjustForRevenueCAGR = false
    
    var body: some View {
        NavigationView {
            List(tableData.indices, id:\.self) { index in
                HStack {
                    Text(self.tableData[index].company)
                    
                    Spacer()
                    
                    Text(String(format: "%.2f", self.tableData[index].multiplier))
                }
                
            }//.onAppear(perform: populateEVEBITDA)
                .navigationBarTitle(Text("EV/EBITDA"))
                .navigationBarItems(
                    leading: Button(action: {
                        self.adjustForRevenueCAGR.toggle()
                        self.adjustTableData()
                    }) { Text("Button") }
                        
            )
//            .navigationViewStyle(DoubleColumnNavigationViewStyle())
        }.navigationViewStyle(StackNavigationViewStyle())
    }
    
    func populateEVEBITDA() {
        tableData = priceToEarningsRatioForAllCompanies.map({ ($0.name, $0.ratio) })
    }
    
    func adjustTableData() {

//        let adjustedForCagrString = String(format: "%.1f", company.ratio / self.revenueCAGRforAllCompanies.first(where: {$0.company == company.name})!.revenueCAGR)

//        let regularPriceToEarningsString = String(format: "%.1f", company.ratio)

        if adjustForRevenueCAGR {
            tableData = priceToEarningsRatioForAllCompanies.map({ (peRatio) -> (company: String, multiplier: Double) in
                return (peRatio.name, peRatio.ratio / 100 / self.revenueCAGRforAllCompanies.first(where: {$0.company == peRatio.name})!.revenueCAGR)
            }).sorted(by: {$0.multiplier < $1.multiplier})
        } else {
            tableData = priceToEarningsRatioForAllCompanies.map({ ($0.name, $0.ratio) })
        }
    }
    
//    func evEBITDAAdjustForCAGR() {
//        for i in 0..<companiesWithEVEBITDAdjustedForRevenueCAGR.count {
//            if let cagr = revenueCAGRforAllCompanies.first(where: {$0.company == companiesWithEVEBITDAdjustedForRevenueCAGR[i].name}) {
//                companiesWithEVEBITDAdjustedForRevenueCAGR[i].evEBITDA = companiesWithEVEBITDAdjustedForRevenueCAGR[i].evEBITDA / cagr.revenueCAGR
//            } else {
//                Logger.log(error: "NO CAGR FOUND")
//            }
//        }
//        print("Before sorting: \(companiesWithEVEBITDAdjustedForRevenueCAGR)")
//        companiesWithEVEBITDAdjustedForRevenueCAGR.sort(by: {$0.evEBITDA < $1.evEBITDA})
//        print("After sorting: \(companiesWithEVEBITDAdjustedForRevenueCAGR)")
//    }
}

#if DEBUG
struct EV_EBITDA_Previews: PreviewProvider {
    static var previews: some View {
        EV_EBITDA()
    }
}
#endif

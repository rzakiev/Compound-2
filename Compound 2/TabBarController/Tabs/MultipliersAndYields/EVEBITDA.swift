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
    
    @State var companiesWithEVEBITDAdjustedForRevenueCAGR = [EVEBITDA]()
    
    @State var adjustForRevenueCAGR = false
    
    var body: some View {
        NavigationView {
            List(companiesWithEVEBITDAdjustedForRevenueCAGR) { company in
                HStack {
                    Text(company.name)
                    Spacer()
                    Text(String(format: "%.1f", company.evEBITDA))
                }
                
            }.onAppear(perform: populateEVEBITDA)
                .navigationBarTitle(Text("EV/EBITDA"))
                .navigationBarItems(
                    leading: Button(action: {
                        self.evEBITDAAdjustForCAGR()
                    }) { Text("Button") }
            )
        }
    }
    
    func populateEVEBITDA() {
        DispatchQueue.main.async {
            self.companiesWithEVEBITDAdjustedForRevenueCAGR = Multipliers.evEBITDAForAllCompanies()
            print(self.companiesWithEVEBITDAdjustedForRevenueCAGR)
        }
    }
    
    func evEBITDAAdjustForCAGR() {
        for i in 0..<companiesWithEVEBITDAdjustedForRevenueCAGR.count {
            if let cagr = revenueCAGRforAllCompanies.first(where: {$0.company == companiesWithEVEBITDAdjustedForRevenueCAGR[i].name}) {
                companiesWithEVEBITDAdjustedForRevenueCAGR[i].evEBITDA = companiesWithEVEBITDAdjustedForRevenueCAGR[i].evEBITDA / cagr.revenueCAGR
            } else {
                Logger.log(error: "NO CAGR FOUND")
            }
        }
        print("Before sorting: \(companiesWithEVEBITDAdjustedForRevenueCAGR)")
        companiesWithEVEBITDAdjustedForRevenueCAGR.sort(by: {$0.evEBITDA < $1.evEBITDA})
        print("After sorting: \(companiesWithEVEBITDAdjustedForRevenueCAGR)")
    }
}

#if DEBUG
struct EV_EBITDA_Previews: PreviewProvider {
    static var previews: some View {
        EV_EBITDA()
    }
}
#endif

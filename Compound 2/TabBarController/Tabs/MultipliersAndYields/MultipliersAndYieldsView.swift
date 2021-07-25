//
//  EV:EBITDA.swift
//  Compound 2
//
//  Created by Robert Zakiev on 14.10.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct MultipliersAndYieldsView: View {
    
//    @State var selectedTab: Multiplier = .dividendYield
    
//    @State var adjustData = false //indicates if multipliers must be adjusted
    
    @StateObject var dataProvider = MultipliersAndYieldsDataProvider()
    
    var body: some View {
        NavigationView {
            VStack {
//                Picker(selection: $selectedTab, label: Text("")) {
//                    ForEach([Multiplier.dividendYield, .priceToEarnings], id: \.self) { multiplier in
//                        Text(multiplier.title)
//                    }
//                }.pickerStyle(SegmentedPickerStyle())
                List {
//                    if selectedTab == .priceToEarnings {
//                        priceToEarningsList
//                    } else if selectedTab == .dividendYield {
                        dividendList
//                    } else {
                        
//                    }
                }
//                .listStyle(GroupedListStyle())
                .navigationBarTitle("Dividend Yield", displayMode: .inline)
            }
            
//            .navigationBarItems(trailing: adjustForCAGRButton)
        }
    }
    
    var dividendList: some View {
//        ForEach(["Фиксированный Дивиденд", "Переменный Дивиденд"], id: \.self) { sectionTitle in
        Group {
            Section(header: Text("Фиксированный Дивиденд")) {
                ForEach(dataProvider.dividendYields.fixedDividends) { yield in
                    HStack {
                        Text(yield.ticker)
                        Spacer()
                        Text(String(format: "%.2f", yield.yield) + " %")
                            .foregroundColor(yield.yield < C.Macro.interestRateInRussia ? Color.red : .green)
                    }
                }
            }
            Section(header: Text("Переменный Дивиденд")) {
                ForEach(dataProvider.dividendYields.variableDividends) { yield in
                    HStack {
                        Text(yield.ticker)
                        Spacer()
                        Text(String(format: "%.2f", yield.yield) + " %")
                            .foregroundColor(yield.yield < C.Macro.interestRateInRussia ? Color.red : .green)
                    }
                }
                
            }
        }
    }
    
//    var priceToEarningsList: some View {
//        return ForEach(dataProvider.getPERatios(adjusted: adjustData)) { multiplier in
//            HStack {
//                Text(multiplier.ticker)
//                Spacer()
//                Text(String(format: "%.2f", multiplier.ratio))
//                    .foregroundColor(multiplier.ratio < ConstantsMacro.interestRateYield ? Color.green : Color.red)
//            }
//        }
//    }
//
//    //MARK: - Buttons
//    var adjustForCAGRButton: some View {
//        Toggle(isOn: $adjustData) {
//            Text("Adjust For Cagr")
//        }
//    }
//
//    var adjustForPayoutRatioButton: some View {
//        Button(action: {self.adjustData.toggle()
//
//        }) {
//            Text("Поправка На Рост")
//        }
//    }
//
    //    //MARK: - TableData
    //    var priceToEarningsData: some View {
    //        let priceToEarningsRatios = dataProvider.priceToEarningsRatios(adjustedForCAGR: self.adjustData)
    //        return ForEach(priceToEarningsRatios.indices, id: \.self) { index in
    //            HStack {
    //                Text(priceToEarningsRatios[index].name)
    //                Spacer()
    //                Text(String(self.adjustForCAGR ? priceToEarningsRatios[index].multiplier : priceToEarningsRatios[index].multiplier / priceToEarningsRatios[index].cagr))
    //            }
    //        }
    //    }
    
    //    init() {
    ////        dataProvider._selectedTab =
    //    }
}
#if DEBUG
struct EV_EBITDA_Previews: PreviewProvider {
    static var previews: some View {
            MultipliersAndYieldsView()
                .colorScheme(.dark)
//                .previewLayout(.sizeThatFits)
        
        
    }
}
#endif

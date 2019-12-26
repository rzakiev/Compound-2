//
//  ChartList.swift
//  Compound 2
//
//  Created by Robert Zakiev on 01/09/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct FinancialChartList: View {
    
    let company: Company
    
    @State private var marketCap: Double? //Displayed in the multipliersView and also used for calculating varios ratios
    
    var body: some View {
        
        List {
            
            financialChartList
            
            if company.isPublic {
                multipliersView
            }
         }
         //.navigationBarTitle(Text(company.name + ("(₽ \(String(marketCap?.simplify() ?? "N/A")))")), displayMode: .inline)
         .onAppear(perform: fetchQuote)
         //.modifier(ChartListModifier())
    }
    
    var financialChartList: some View {
        Section(header: Text("Финансовые индикаторы")) {
            ForEach(company.availableIndicators(), id: \.self) { indicator in
                Chart(for: indicator,
                      grossGrowth: self.company.grossGrowthRate(for: indicator),
                      values: self.company.growthRate(for: indicator)!)
            }
        }
    }
    
    var multipliersView: some View {
        HStack {
            Text("Капитализация:")
            Spacer()
            Text(marketCap != nil ? marketCap!.simplify() : "N/A")
        }
    }
}

//MARK: - Managing Quotes
extension FinancialChartList {
    func fetchQuote() {
        
        let marketCapUpdater: (Double) -> Void = { marketCapitalization in
            DispatchQueue.main.async {
                self.marketCap = marketCapitalization
            }
        }
        
        if company.isPublic {
            company.fetchMarketCapitalization(completion: marketCapUpdater)
        }
    }
}

//MARK: - SwiftUI Previews
#if DEBUG
//struct ChartListModifier: ViewModifier {
//
//    func body(content: Content) -> some View {
//        return content.padding(-10)
//    }
//}

struct ChartList_Previews: PreviewProvider {
    static var previews: some View {
        FinancialChartList(company: Company(name: "Сбербанк"))//.modifier(ChartListModifier())
    }
}
#endif

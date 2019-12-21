//
//  ChartList.swift
//  Compound 2
//
//  Created by Robert Zakiev on 01/09/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct ChartList: View {
    
    let company: Company
    
    @State private var marketCap: Double?
    
    var body: some View {
        
         List {
            chartList
         }
         //.navigationBarTitle(Text(company.name + ("(₽ \(String(marketCap?.simplify() ?? "N/A")))")), displayMode: .inline)
         .onAppear(perform: fetchQuote)
         .modifier(ChartListModifier())
    }
    
    var chartList: some View {
        ForEach(company.availableIndicators(), id: \.self) { indicator in
            Chart(for: indicator,
                  grossGrowth: self.company.grossGrowthRate(for: indicator),
                  values: self.company.growthRate(for: indicator)!)
        }
    }
}

//MARK: - Managing Quotes
extension ChartList {
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
struct ChartListModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        return content.padding(-10)
    }
}

struct ChartList_Previews: PreviewProvider {
    static var previews: some View {
        ChartList(company: Company(name: "Сбербанк")).modifier(ChartListModifier())
    }
}
#endif

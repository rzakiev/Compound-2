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
            if company.isPublic { //If the company is public, display a block with the market capitalization, dividend yield, and so on
                multipliersView
            }
            if company.moexDividends != nil {
                dividendsView
            }
        }
    }
    
    
    
    
    var financialChartList: some View {
        Section(header: Text("Финансовые индикаторы")) {
            //            ScrollView(.vertical, showsIndicators: false) {
            ForEach(company.availableIndicators(), id: \.self) { indicator in
                Chart(for: indicator,
                      grossGrowth: self.company.grossGrowthRate(for: indicator),
                      values: self.company.chartValues(for: indicator)!)
            }
            //            }
        }.edgesIgnoringSafeArea([.horizontal])
            .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
    
    var multipliersView: some View {
        Section(header: Text("Мультипликаторы")) {
            HStack {
                Text("Капитализация:")
                Spacer()
                Text(marketCap?.simplify() ?? "N/A")
            }
        }.frame(width: nil, height: 20, alignment: .center)
            .onAppear(perform: fetchQuote)
    }
    
    var analysisView: some View {
        return Text(InvestmentCase.init(company: company.name, type: .dividendPlay).checkInvestmentThesis().analysis)
            .frame(width: nil, height: 50, alignment: .center)
    }
    
    var dividendsView: some View {
        Section(header: Text("Дивиденды")) {
            ForEach(company.moexDividends![1].dividends!.indices, id: \.self) { index in
                HStack {
                    Text(self.company.moexDividends![1].dividends![index].registryclosedate)
                    Spacer()
                    Text(String(self.company.moexDividends![1].dividends![index].value))
                }
            }
        }
    }
    
    
    init(company: Company) {
        self.company = company
        //        Logger.log(operation: "Initializing the Financial Chart List View FOR COMPANY: \(company.name)")
        fetchQuote()
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

struct ChartList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            FinancialChartList(company: Company(name: "Сбербанк")).colorScheme(scheme)//.modifier(ChartListModifier())
        }
    }
}
#endif

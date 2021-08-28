//
//  ChartList.swift
//  Compound 2
//
//  Created by Robert Zakiev on 01/09/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI
import Combine

final class ChartListDataProvider: ObservableObject {
    
    @Published var marketCap: Double?
    
    let ticker: String
    
    private var quoteSubscriber: AnyCancellable?
    
    init(ticker: String) {
        
        self.ticker = ticker
        
        quoteSubscriber = MoexQuoteService.shared.$allQuotes.receive(on: DispatchQueue.global()).sink(receiveValue: { [unowned self] (_) in
            guard let newQuote = MoexQuoteService.shared.allQuotes.first(where: { $0.ticker == ticker }) else { return }
            marketCap = newQuote.marketCap
        })
    }
}


struct FinancialChartList: View {
    
    let company: CompanyName
    
    private let financialFigures: Company?
    
    @State private var marketCap: Double? //Displayed in the multipliersView and also used for calculating varios ratios
    
    private var dividends: [DividendElement]?
    
    @ObservedObject var dataProvider: ChartListDataProvider
    
    
    var body: some View {
        
        List {
            if financialFigures != nil {
                financialChartList
            }
            
            multipliersView
            
            if dividends != nil {
                dividendsView
            }
        }
    }
        
    var financialChartList: some View {
        return Section(header: Text("Финансовые индикаторы")) {
            //            ScrollView(.vertical, showsIndicators: false) {
            ForEach(self.financialFigures!.availableIndicators(), id: \.self) { indicator in
                Chart(for: indicator,
                      grossGrowth: financialFigures?.grossGrowthRate(for: indicator),
                      values: self.financialFigures!.chartValues(for: indicator)!)
            }
        }.edgesIgnoringSafeArea([.horizontal])
        .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
    
    var multipliersView: some View {
        Section(header: Text("Мультипликаторы")) {
            HStack {
                Text("Капитализация:")
                Spacer()
                Text(dataProvider.marketCap == nil ? "N/A" : String(dataProvider.marketCap!.beautify()))
            }
        }.frame(width: nil, height: 20, alignment: .center)
            .onAppear(perform: fetchQuote)
    }
    
//    var analysisView: some View {
//        return Text(InvestmentCase.init(company: company.name, type: .dividendPlay).checkInvestmentThesis().analysis)
//            .frame(width: nil, height: 50, alignment: .center)
//    }
//
    var dividendsView: some View {
        return Section(header: Text("Дивиденды")) {
            ForEach(dividends!.indices, id: \.self) { index in
                HStack {
                    Text(dividends![index].registryclosedate)
                    Spacer()
                    Text(String(dividends![index].value))
                    Text(String(dividends![index].currencyid))
                }
            }
        }
    }
    
    
}

//MARK: - Initializers
extension FinancialChartList {
    init(company: CompanyName) {
        self.company = company
//        if company.ticker != nil {
        self.dividends = MoexDataManager.getDividendDataLocally(forTicker: company.ticker)?.dividends?.reversed()
//        }
        self.financialFigures = Company(name: company)
        self.dataProvider = ChartListDataProvider(ticker: company.ticker)
        
//        quoteSubscriber = QuoteService.shared.$allQuotes.receive(on: DispatchQueue.main).sink(receiveValue: { (quotes) in
//            guard let newQuote = quotes.first(where: { $0.ticker == company.ticker }) else { return }
//            self.marketCap = MarketCapitalization.getMarketCapitalization(for: company.ticker, currentQuote: newQuote)
//        })
//        else { self.financialFigures = nil }
    }
}

extension FinancialChartList {
}

//MARK: - Managing Quotes
extension FinancialChartList {
    func fetchQuote() {
        
//        let marketCapUpdater: (Double) -> Void = { marketCapitalization in
//            DispatchQueue.main.async {
//                self.marketCap = marketCapitalization
//            }
//        }
//
//        if company.isPublic {
//            company.fetchMarketCapitalization(completion: marketCapUpdater)
//        }
    }
}

//MARK: - SwiftUI Previews
#if DEBUG

struct ChartList_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            FinancialChartList(company: .init(name: "Севка)", ticker: "CHMF")).colorScheme(scheme)//.modifier(ChartListModifier())
        }
    }
}
#endif

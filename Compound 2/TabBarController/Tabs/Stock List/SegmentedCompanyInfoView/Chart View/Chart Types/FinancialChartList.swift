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
    
    @Published var quote: SimpleQuote?
    
    var financialFigures: Company?
    
    let ticker: String
    
    private var quoteSubscriber: AnyCancellable?
    
    init(ticker: String) {
        
        self.ticker = ticker
        
        self.financialFigures = Company(ticker: ticker)
        
        quoteSubscriber = MoexQuoteService.shared.$allQuotes.receive(on: DispatchQueue.main).sink(receiveValue: { [unowned self] (_) in
            guard let newQuote = MoexQuoteService.shared.allQuotes.first(where: { $0.ticker == ticker }) else { return }
            quote = newQuote
            marketCap = newQuote.marketCap ?? MarketCapitalization.getMarketCapitalization(for: ticker, currentQuote: newQuote)
        })
        
        Task {
            let securityGeography = C.Tickers.securityGeography(for: ticker)
            switch securityGeography {
            case .unknown: break
            case .russia: await SmartlabDataService.fetchData(for: ticker, saveToLocalStorage: true)
            case .foreign: await PolygonDataService.fetchHistoricalFinancialData(for: ticker)
            }
            
            self.financialFigures = Company(ticker: ticker)
        }
    }
}


struct FinancialChartList: View {
    
    let company: CompanyName
    
    
    
    @State private var marketCap: Double? //Displayed in the multipliersView and also used for calculating varios ratios
    
    private var dividends: [DividendElement]?
    
    @EnvironmentObject var dataProvider: ChartListDataProvider
    
    var body: some View {
        
        List {
            if dataProvider.financialFigures != nil {
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
            ForEach(dataProvider.financialFigures!.availableIndicators(), id: \.self) { indicator in
                Chart(for: indicator,
                         grossGrowth: dataProvider.financialFigures?.grossGrowthRate(for: indicator),
                      values: dataProvider.financialFigures!.chartValues(for: indicator)!)
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

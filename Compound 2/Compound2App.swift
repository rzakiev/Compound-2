//
//  Compound2App.swift
//  Compound 2
//
//  Created by Robert Zakiev on 22.02.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import SwiftUI
import CoreData

@main
struct Compound2App: App {
    
    init() {
        performNecessaryOperationsOnLaunch()
        testStuff()
    }
    
    var body: some Scene {
        WindowGroup {
            CompoundRootTabBarController().preferredColorScheme(.light)
        }
    }
}

//MARK: - Operatons that must be performed whenever the app is launched
extension Compound2App {
    ///Performs the required operation during every launch of the app
    func performNecessaryOperationsOnLaunch() {
        
        performNecessaryOperationsOnFirstLaunch()
        
        Task { await MoexQuoteService.shared.getAllQuotes() }
        
        //        Task { await SmartlabDataService.fetchDataForAllTickers() }
        
        MoexDataManager.updateAllLocalDataFromMoex()
        YahooQuoteService.shared.getAllQuotesAsync()
        
        Task { await PolygonDataService.fetchHistoricalFinancialData(for: ["AMZN", "KO", "PBF", "BIDU", "BABA", "OXY"]) }
    }
    
    ///Performs the required operation only during the first launch of the app
    func performNecessaryOperationsOnFirstLaunch() {
        Preferences.setDefaultPreferencesOnFirstLaunch()
    }
}

//MARK: - Just some test stuff
extension Compound2App {
    func testStuff() {
        let author = "malishok"
//        var ideas = [InvestmentIdea]()
        
//        ideas.append(.init(authorName: author, ticker: "BABA", currency: .USD, targetPrice: 240, priceOnOpening: nil, openingDate: nil, risk: "medium", companyName: "Alibaba", investmentThesis: nil))
        
//        ideas.append(.init(authorName: author, ticker: "BIDU", currency: .USD, targetPrice: 230, priceOnOpening: nil, openingDate: nil, risk: "medium", companyName: "Baidu", investmentThesis: nil))
        
//        let ideasSet = InvestmentIdeas(author: author, values: ideas)
//
//        let _ = ideasSet.asCoreDataEntity()
        
//        ideas.forEach { idea in
//            let _ = idea.asCoreDataEntity()
//        }
        
        do {
            try CoreDataManager.shared.context.save()
        } catch (let error ) {
            print("Unable to save investment ideas: Error: \(error)")
        }
        
        //        if let dollar = try? CoreDataManager.shared.context.fetch(request), dollar.isNotEmpty {
        //            print(dollar)
        //        } else {
        //            let dollar = CurrencyItem_(context: CoreDataManager.shared.context)
        //            dollar.name = "US Dollar"
        //            dollar.shortName = "USD"
        //            dollar.symbol = "$"
        //            do {
        //                try CoreDataManager.shared.context.save()
        //            } catch (let error ){
        //                print("Unable to save the current DB context. Error: \(error)")
        //            }
        //        }
    }
}




//
//  Compound2App.swift
//  Compound 2
//
//  Created by Robert Zakiev on 22.02.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import SwiftUI

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
        
        Task { await SmartlabDataService.fetchDataForAllTickers() }
        
        MoexDataManager.updateAllLocalDataFromMoex()
        YahooQuoteService.shared.getAllQuotesAsync()
//        YahooFinancialDataService.fetchQuoteAndDividendHistoryForAllCompaniesAsync()
//        YahooFinancialDataService.fetchQuoteAndDividendHistoryAsync(for: "PBF", startDate: "04/01/2010", endDate: "05/05/2021", interval: .oneMonth) {_ in }
    }
    
    ///Performs the required operation only during the first launch of the app
    func performNecessaryOperationsOnFirstLaunch() {
        Preferences.setDefaultPreferencesOnFirstLaunch()
    }
}

//MARK: - Just some test stuff
extension Compound2App {
    func testStuff() {
        //Task { await PolygonDataService.fetchHistoricalFinancialData(for: "PBF") }
    }
}

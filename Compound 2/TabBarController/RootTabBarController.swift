//
//  RootTabBarController.swift
//  Compound 2
//
//  Created by Robert Zakiev on 16.08.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI


struct RootTabBarController: View {
    
//    let quotes = (try? FinancialDataManager.getSmartlabLinks()) ?? ["No quotes" : "Coudn't fetch quotes"]
    
    var body: some View {
        return TabView {
            StockListAndDetailNavigationView()
                .modifier(RootTabBarControllerModifier(backgroundImage: "Stocks Tab Bar Icons", tabName: "Компании"))
            StatisticsTab()
                .modifier(RootTabBarControllerModifier(backgroundImage: "Stocks Tab Bar Icons", tabName: "Статистика"))
            MultipliersAndYieldsView()
                .modifier(RootTabBarControllerModifier(backgroundImage: "Stocks Tab Bar Icons", tabName: "Мультики"))
            
            PortfolioView()
                .modifier(RootTabBarControllerModifier(backgroundImage: "Portfolio  Tab Bar Icons", tabName: "Портфолио")) //test tab
            #if DEBUG
            TestsView()
                .modifier(RootTabBarControllerModifier(backgroundImage: "Stocks Tab Bar Icons", tabName: "Тесты")) //test tab
            #endif
        }
    }
    
    init() {
        Preferences.setDefaultPreferencesOnFirstLaunch()
        QuoteService.shared.getAllQuotesAsync()
    }
}

struct RootTabBarControllerModifier: ViewModifier {
    
    @State private var backgroundImage: String
    @State private var tabName: String
    
    init(backgroundImage: String, tabName: String) {
        _backgroundImage = State(initialValue: backgroundImage)
        _tabName = State(initialValue: tabName)
    }
    
    func body(content: Content) -> some View {
        return content.tabItem {
            Image(backgroundImage)
            Text(tabName)
        }
    }
}

#if DEBUG
struct RootTabBarControllerPreview: PreviewProvider {
    static var previews: some View {
        RootTabBarController()
    }
}
#endif

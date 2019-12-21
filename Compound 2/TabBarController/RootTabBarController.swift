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
    
    let quotes = (try? FinancialDataManager.getSmartlabLinks()) ?? ["No quotes" : "Coudn't fetch quotes"]
    
    var body: some View {
        return TabView {
            StockListAndDetailNavigationView()
                .modifier(RootTabBarControllerModifier(tabNumber: 1, tabName: "Компании"))
            StatisticsTab()
                .modifier(RootTabBarControllerModifier(tabNumber: 2, tabName: "Статистика"))
            EV_EBITDA().modifier(RootTabBarControllerModifier(tabNumber: 2, tabName: "EV/EBITDA"))
            Alerts().modifier(RootTabBarControllerModifier(tabNumber: 2, tabName: "Tests"))
        }
    }
    
    init() {
        Preferences.setDefaultPreferencesOnFirstLaunch()
    }
}

struct RootTabBarControllerModifier: ViewModifier {
    
    @State var tabNumber: Int
    @State var tabName: String
    
    func body(content: Content) -> some View {
        return content.tabItem {
            Image(systemName: String(tabNumber) + ".square.fill")
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

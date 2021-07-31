//
//  RootTabBarController.swift
//  Compound 2
//
//  Created by Robert Zakiev on 16.08.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

struct CompoundRootTabBarController: View {
    
    @State var displayStartUpView = true//Preferences.isFirstLaunch
    
    var body: some View {
        return TabView {
            StockListAndDetailNavigationView()
                .modifier(RootTabBarControllerModifier(backgroundImage: "Stocks Tab Bar Icons", tabName: "Компании"))
            MultipliersAndYieldsView()
                .modifier(RootTabBarControllerModifier(backgroundImage: "Stocks Tab Bar Icons", tabName: "Мультики"))
            PortfolioView()
                .modifier(RootTabBarControllerModifier(backgroundImage: "Portfolio  Tab Bar Icons", tabName: "Портфолио")) //test tab
//            DividendCalendar()
//            #if DEBUG
            IdeasUpsideNavigationView()
                .tabItem { Image(systemName: "arrow.up.right"); Text("Идеи") }
            PortfolioReturnsView()
                .modifier(RootTabBarControllerModifier(backgroundImage: "", tabName: "Доходность"))
//            TestsView()
//                .tabItem { Image(systemName: "gearshape"); Text("Тесты") }
//                .modifier(RootTabBarControllerModifier(backgroundImage: "Stocks Tab Bar Icons", tabName: "Тесты")) //test tab
//            #endif
        }//.fullScreenCover(isPresented: $displayStartUpView) { StartupView(displayStartupView: $displayStartUpView) }
    }
    
    init() {
       
    }
}



//MARK: - View Modifier for the Tab Bar Controller
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
struct CompoundRootTabBarControllerPreview: PreviewProvider {
    static var previews: some View {
        CompoundRootTabBarController()
    }
}
#endif

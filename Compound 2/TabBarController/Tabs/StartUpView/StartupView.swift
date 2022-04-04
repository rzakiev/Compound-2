//
//  StartupView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 21.12.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import SwiftUI

final class StartUpViewDataManager: ObservableObject {
    @Published var allTasksAreDone = false
    
    init() {
        Task { await downloadSmartLabData() }
    }
    
    func downloadSmartLabData() async {
        await SmartlabDataService.fetchDataForAllTickers()
        self.allTasksAreDone = true
    }
}

///Displayed upon the first launch of the app
struct StartupView: View {
    
    @StateObject var dataManager = StartUpViewDataManager()
    
    @Binding var displayStartupView: Bool
    
    var body: some View {
//        NavigationView {
//            NavigationLink(destination :
//                            CompoundRootTabBarController()) {
                
                DotActivitySpinner()//.onTapGesture { startDataFetchingTimer() }
//            }
//        }
    }
    
    init(displayStartupView: Binding<Bool>) {
        _displayStartupView = displayStartupView
    }
}

extension StartupView {
   
}


struct StartupView_Previews: PreviewProvider {
    
    @State static var displayView = true
    
    static var previews: some View {
        StartupView(displayStartupView: $displayView)
    }
}


/*
 NavigationLink(destination: SegmentedCompanyInfoView(company: company)) {
 StockListCell(companyName: company.name, cagr: nil)
 }
 */

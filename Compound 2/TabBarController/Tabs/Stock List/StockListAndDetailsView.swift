//
//  StockListAndDetailsView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 25/08/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

//struct StockListAndDetailsView: View {
//    
//    var body: some View {
//        switch UIDevice.current.userInterfaceIdiom {
//        case .phone:
//            return StockListAndDetailNavigationView()
//        case .pad:
//            return StockListAndDetailNavigationView()
//        default:
//            return StockListAndDetailNavigationView()
//        }
//    }
//}



//Navigation view for iPhones
struct StockListAndDetailNavigationView: View {
    
    private let preferredCompanySortingCriteria = PreferredCompanySortingCriterion.byName
    
    //    private let companiesSortedByIndustries:[IndustryWithCompaniesCAGR] = Statistics.companiesSortedByIndustryAndRevenueCAGR()
    
    //    private let companyCagrValues = Statistics.companiesSortedByRevenueCAGR()
    
    @State private var companyList = C.Tickers.allTickerSymbolsWithNames().sorted(by: { $0.name < $1.name })
    
    @State private var userSearchInput = ""
    
    var body: some View {
        return NavigationView {
            VStack {
                CompanyListSearchBar(text: $userSearchInput, onSearchButtonClicked: endEditing)
                List {
                    if !userSearchInput.isEmpty { companyListForSearchMode }
                        
                    else { companiesSortedByNameList }
                    }.navigationBarTitle("Компании", displayMode: .inline)
                        .listStyle(GroupedListStyle())
                }
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
            //.edgesIgnoringSafeArea([.top])
        }
        
        //Three types of lists that might be displayed depending on the user's preferences
        //MARK:- Lists of companies sorted based on the user's preferences
        var companiesSortedByNameList: some View {
            //let companyList = FinancialDataManager.listOfAllCompanies().sorted(by: { $0 < $1 })
            //If the user chose to sort companies alphabetically
            return
                ForEach(self.companyList.filter({
                    userSearchInput.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(userSearchInput)
                })) { company in
                    NavigationLink(destination: SegmentedCompanyInfoView(company: company)) {
                        StockListCell(companyName: company.name, cagr: nil)
                    }
            }
        }
        
        var companyListForSearchMode: some View {
            Section(header: Text("Найденные компании")) {
                ForEach(companyList.filter({self.userSearchInput.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.userSearchInput)})) { company in
                    NavigationLink(destination: SegmentedCompanyInfoView(company: company)) {// SegmentedCompanyInfoView(company: company.name)
                        StockListCell(companyName: company.name)
                    }
                }
            }
        }
    }
    
    extension StockListAndDetailNavigationView {
        
        func endEditing() {
            
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to:nil, from:nil, for:nil)
        }
    }
    
    
    
    
    
    #if DEBUG
    struct StockListPreview: PreviewProvider {
        
        static var previews: some View {
            StockListAndDetailNavigationView()
        }
    }
#endif


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
    
    private let preferredCompanySortingCriteria = Preferences.preferredCompanySortingCriterion
    
    private let companiesSortedByIndustries:[IndustryWithCompaniesCAGR] = Statistics.companiesSortedByIndustryAndRevenueCAGR()
    
    private let companyCagrValues = Statistics.companiesSortedByRevenueCAGR()
    
    @State var companyList = FinancialDataManager.listOfAllCompanies().sorted(by: { $0 < $1 })
    
    @State var userSearchInput = ""
    
    var body: some View {
        return NavigationView {
            VStack {
                CompanyListSearchBar(text: $userSearchInput, onSearchButtonClicked: endEditing)
                List {
                    if preferredCompanySortingCriteria == .byIndustry {
                        companiesSortedByIndustryList
                    }
                    else if preferredCompanySortingCriteria == .byName {
                        companiesSortedByNameList
                    }
                    else {
                        companiesSortedByCAGRList
                    }
                }.navigationBarTitle("Компании", displayMode: .inline)
                .listStyle(GroupedListStyle())

            }
            
        }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        .edgesIgnoringSafeArea([.top])
    }
    
    //Three types of lists that might be displayed depending on the user's preferences
    //MARK:- Lists of companies sorted based on the user's preferences
    var companiesSortedByNameList: some View {
        //let companyList = FinancialDataManager.listOfAllCompanies().sorted(by: { $0 < $1 })
        //If the user chose to sort companies alphabetically
        return
            ForEach(self.companyList.filter({
                userSearchInput.isEmpty ? true : $0.localizedCaseInsensitiveContains(userSearchInput)
            }), id: \.self) { company in
                NavigationLink(destination: SegmentedCompanyInfoView(company: company)) {
                    StockListCell(companyName: company, cagr: nil)
                }
            }
    }
    
    var companiesSortedByCAGRList: some View {
        //If the user chose to sort companies by CAGR
        
        
        return ForEach(companyCagrValues.indices, id: \.self) { index in
            NavigationLink(destination: SegmentedCompanyInfoView(company: self.companyCagrValues[index].company)) {
                return StockListCell(companyName: self.companyCagrValues[index].company, cagr: self.companyCagrValues[index].revenueCAGR) //self.companyCagrValues.first(where: {$0.company == name})!.revenueCAGR
                }
            }
    }
    
    var companiesSortedByIndustryList: some View  {
        //If the user chose to sort companies by industry
//        let industryIndices = Array(companiesSortedByIndustries.indices)
        return ForEach(companiesSortedByIndustries, id: \.id) { industry in
            return Section(header: Text(industry.name.uppercased())) { //(header: Text("Hello"))

//                let indices = Array(self.companiesSortedByIndustries[industryIndex].companies.indices)
                return ForEach(industry.companiesSortedByIndustryAndCAGR.filter({
                    self.userSearchInput.isEmpty ? true : $0.name.localizedCaseInsensitiveContains(self.userSearchInput)
                }), id: \.id) { company in //if companies are sorted by industry, return a list with sections
//                        let companyName = self.companiesSortedByIndustries[industryIndex].companies[companyIndex].name
                    return NavigationLink(destination: SegmentedCompanyInfoView(company: company.name)) {// SegmentedCompanyInfoView(company: company.name)

//                            let companyName = self.companiesSortedByIndustries[industryIndex].companies[companyIndex]
//                            let companyCagr = self.companiesSortedByIndustries[industryIndex].companies[companyIndex].revenueCAGR
                        return StockListCell(companyName: company.name,
                                             cagr: company.revenueCAGR)

                    }
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
   

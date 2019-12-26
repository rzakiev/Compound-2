//
//  User Preferences.swift
//  Compound 2
//
//  Created by Robert Zakiev on 21/09/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

struct Preferences {
    
    static let preferredStatisticsTabs = ["revenueGrowth", "dividendGrowth", "profitGrowth"]
    
    static func requiredFinancialIndicators() -> Set<Indicator> {
        let requiredIndicators: Set<Indicator> = [.revenue, .OIBDA, .EBITDA, .netProfit, .freeCashFlow, .dividend, .debtToEBITDA]
        
        return requiredIndicators
    }
    
    static var preferredCompanySortingCriterion: PreferredCompanySortingCriterion {
//        return .byName
        switch getUserPreference(forKey: preferredCompanySortingCriterionKey) {
            
        case sortingByIndustryIsPreferred:
            return .byIndustry
        case sortingByNameIsPreferred:
            return .byName
        case sortingByCAGRIsPreferred:
            return .byCAGR
        default:
            return .byCAGR
        }
    }
    
    static func requiredSegmentsInSegmentedCompanyView(for company: String) -> [CompanyInfoSegment] {
        var requiredSegments: [CompanyInfoSegment] = [.finances]
        
        let ecosystemIsAvailable = FinancialDataManager.resourceIsAvailable(at: FinancialDataManager.ecosystemImagesSubdirectory,
                                                                            named: company,
                                                                            ofType: ".png")
        if ecosystemIsAvailable { requiredSegments.append(.ecosystem) }
        
        let productionFiguresAreAvailable = FinancialDataManager.resourceIsAvailable(at: FinancialDataManager.productionFiguresSubdirectory,
                                                                                     named: company,
                                                                                     ofType: ".png")
        if productionFiguresAreAvailable { requiredSegments.append(.production) }
        
        //let tradingViewLinkIsAvailable = FinancialDataManager.resourceIsAvailable(at: FinancialDataManager.tradingViewLinksSubdirectory,
                                                                                  //named: "TradingViewLinks",
                                                                                  //ofType: "plist")
        //if tradingViewLinkIsAvailable { requiredSegments.append(.tradingView) }
        
        
        
        return requiredSegments.count == 1 ? [] : requiredSegments //if there's only 1 section, no need to display the Picker in SegmentedCompanyInfoView
    }
}

//MARK: - Basic Methods
extension Preferences {
    
    private static func getUserPreference(forKey: String) -> String? {
        return UserDefaults.standard.value(forKey: forKey) as? String
    }
    
    static func setDefaultPreferencesOnFirstLaunch() {
        if UserDefaults.isFirstLaunch() {
            let sharedInstanceOfUserDefaults = UserDefaults.standard
            
            sharedInstanceOfUserDefaults.setValue(sortingByIndustryIsPreferred, forKey: preferredCompanySortingCriterionKey)
        }
    }
}

//MARK: - Constant Strings
private extension Preferences {
    static let preferredCompanySortingCriterionKey = "preferredCompanySortingcriterionKey"//Key
    static let sortingByIndustryIsPreferred = "sortingByIndustryIsPreferred"//Value 1
    static let sortingByNameIsPreferred = "sortingByNameIsPreferred"//Value 2
    static let sortingByCAGRIsPreferred = "sortingByCAGRIsPreferred"//Value 3
 
    static let productionFiguresAreAvailableKey = "productionFiguresAreAvailable"
    static let ecosystemIsAvailableKey = "ecosystemIsAvailable"
    static let tradingViewIsAvailableKey = "tradingViewIsAvailable"
}

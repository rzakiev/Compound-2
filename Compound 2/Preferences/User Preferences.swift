//
//  User Preferences.swift
//  Compound 2
//
//  Created by Robert Zakiev on 21/09/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

///Contains methods for retrieving the user's local settings
struct Preferences {
    
    static func requiredFinancialChartIndicators() -> [Indicator] {
        let requiredIndicators: [Indicator] = [.revenue, .freeCashFlow, .dividend] // .OIBDA, .EBITDA, .netProfit, .freeCashFlow, .debtToEBITDA
        
        return requiredIndicators
    }
    
    static var preferredCompanySortingCriterion: PreferredCompanySortingCriterion {
        
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
        
        if ProductionDataManager.productionFiguresAreAvailable(for: company) { requiredSegments.append(.production) }
        
        return requiredSegments
    }
}

//MARK: - Basic Methods
extension Preferences {
    
    private static func getUserPreference(forKey: String) -> String? {
        return UserDefaults.standard.value(forKey: forKey) as? String
    }
    
    ///Checks if this is the very first launch of the app and sets all of the default settings
    static func setDefaultPreferencesOnFirstLaunch() {
        if isFirstLaunch {
            let sharedUserDefaults = UserDefaults.standard
            sharedUserDefaults.setValue(sortingByNameIsPreferred, forKey: preferredCompanySortingCriterionKey)
        }
    }
}

//MARK: - Convenience methods and properties
extension Preferences {
    static var isFirstLaunch: Bool { UserDefaults.isFirstLaunch() }
}

//MARK: - Constant Strings
private extension Preferences {
    
    //MARK: - Picker view preferences
    static let requiredStatisticsTabs = ["revenueGrowth", "dividendGrowth", "profitGrowth"]
    
    static let requiredMultupliersAndYieldsTabs = ["priceToEarnings", "evEBITDA", "dividendYield"]
    
    static let preferredCompanySortingCriterionKey = "preferredCompanySortingcriterionKey"//Key
    static let sortingByIndustryIsPreferred = "sortingByIndustryIsPreferred"//Value 1
    static let sortingByNameIsPreferred = "sortingByNameIsPreferred"//Value 2
    static let sortingByCAGRIsPreferred = "sortingByCAGRIsPreferred"//Value 3
 
    static let productionFiguresAreAvailableKey = "productionFiguresAreAvailable"
    static let ecosystemIsAvailableKey = "ecosystemIsAvailable"
    static let tradingViewIsAvailableKey = "tradingViewIsAvailable"
}

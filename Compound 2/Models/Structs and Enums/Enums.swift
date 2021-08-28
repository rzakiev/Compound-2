//
//  Enums.swift
//  Compound 2
//
//  Created by Robert Zakiev on 15.08.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
//import SwiftUI

enum OperatingIncomeType {
    case EBITDA
    case OIBDA
}

enum CompetitionType {
    case low
    case medium
    case high
    case monopoly
}

enum Indicator: Equatable, Hashable {
    
    //MAIN ONES
    case revenue
    case freeCashFlow
    case dividend
    
    case custom(name: String)
    
    case debtToEBITDA
    case OIBDA
    case EBITDA
    case netIncome

    case commissionIncome
    case interestIncome
    case production(produceName: String, unitOfMeasurement: String?)
    
    var title: String {
        switch self {
        case .revenue: return "Выручка"
        case .dividend: return "Дивиденды"
        case .netIncome: return "Чистая Прибыль"
        case .freeCashFlow: return "FCF"
        case .custom(let name): return name
        default: return "Unknow Indicator"
        }
    }
    
//    init(from smartlabIndicator: String) {
//        
//        for indicator in existingSmartlabIndicators {
//            if smartlabIndicator.contains(indicator) {
//                switch indicator {
//                case "Див.выплата": self = .dividend
//                case "Выручка": self = .revenue
//                case "FCF, млрд руб": self = .freeCashFlow
//                default:
//                    self = .undefined
//                }
//            } else {
//                self = .undefined
//            }
//        }
//    }
}

//
enum PreferredCompanySortingCriterion {
    case byName
    case byCAGR
    case byIndustry
}

//MARK:- Parsing Data
enum PlistParsingError: Error, Equatable {
    case unableToGetPlistPathFor(_ company: String)
    case unableToGetPathForResource(_ resource: String)
    case unableToLoadDataAt(_ path: String)
    case unableToGetCompanyData
    case unableToDowncastObjectiveCObjectAsSwiftEntity
    case unableToSerializeObject
    case unableToFindNumberOfSharesIssued
}

enum PortfolioSaveError: Error {
    case unableToSavePortfolio(reason: String)
    case tryingToSaveEmptyPortfolio
}

//MARK: - Multipliers
enum Multiplier: CaseIterable {
    
    case priceToEarnings
    case EVtoEBITDA
    case dividendYield
    
    var title: String {
        switch self {
        case .priceToEarnings: return "P/E"
        case .EVtoEBITDA: return "EV/EBITDA"
        case .dividendYield: return "Див. Доходность"
        }
    }
}

enum MultiplierAdjustment {
    case forCAGR
    case forPayoutRatio
}

//MARK: - Invesments
enum InvestmentType: String { //: CaseIterable
    case undefined
    case dividendPlay = "Рассчитываю на дивиденды" //Investment case in which an investor expects decent dividends from the company
    case growthPlay = "Считаю, что компания будет расти" //Investment case in which an investor expects the company to appreciably grow
    //case ecosystemPlay //Investment case in which an investor expects the company to leverage its ecosystems to acheive above-average growth
    //case monopoly //Investment case that rests on the company's moat that will enable it to preserver its market share and maintains its income and dividends
}

enum InvestmentRisk {
    case horrificManagement
    case unlikelyToGrow
    case cyclicalIndustry
    case sensitiveToCrises
    case maySuspendDividends
    
    var riskValue: Int {
        switch self {
        case .horrificManagement: return 100
        case .unlikelyToGrow: return 50
        case .cyclicalIndustry: return 40
        case .sensitiveToCrises: return 30
        case .maySuspendDividends: return 20
//        default:
//            return 10
        }
    }
}

enum CompetitiveAdvantage: String {
    case undefined
    case businessIsOperatingInGrowingIndustry
    case businessIsCAPEXLight
    case businessProducePricesAreStable
    case qualityManagement
    case stableDividends
}

//MARK: - Preferences
enum CompanyInfoSegment: String, CaseIterable {
    case finances = "Финансы"
    case production = "Производство"
    case ecosystem = "Экосистема"
    case tradingView = "Trading View"
}




//MARK: - File System
enum FileSystemError: Error {
    case failedToCreateFile(named: String, atPath: String, reason: String)
    case failedToReadFile(named: String, atPath: String, reason: String)
}


//MARK: - Time
enum TimePeriod {
    case second
    case minute
    case hour
    case day
    case undefined
}

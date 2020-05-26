//
//  Constants.swift
//  Compound 2
//
//  Created by Robert Zakiev on 25/09/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import UIKit


//MARK: - Companies
struct CorporateConstants {
    static let industries: [(name: String, companies:[String])] = [
        ("Авиа" , ["Аэрофлот"]),
        ("Авиастроение", ["ОАК"]),
        ("ГОСТИНИЦЫ" , ["Cosmos Group"]),
        ("ДЕРЕВООБРАБОТКА" , ["Сегежа"]),
        ("Инфраструктура", ["НМТП"]), //"ДВМП"
        ("ИТ" , ["РТИ", "Яндекс", "Сбербанк", "АФК Система", "МТС", "Ростелеком", "Tinkoff"]),
        ("МЕДИЦИНА" , ["Медси", "Alium", "Синтез"]), //"Протек"
        ("МЕТАЛЛЫ" , ["Норильский Никель", "Северсталь", "НЛМК", "ММК", "Русал", "ВСМПО-Ависма"]),
        ("НЕДВИЖИМОСТЬ" , ["Группа ЛСР", "Эталон"]),
        ("РИТЕЙЛ" , ["Ozon", "Детский Мир", "X5 Retail Group", "Магнит"]),
        ("СЕЛЬСКОЕ ХОЗЯЙСТВО" , ["Степь", "Русагро"]),
        ("ФИНАНСЫ" , ["Московская Биржа", "ВТБ"]),
        ("ЭЛЕКТРОЭНЕРГЕТИКА" , ["ФСК ЕЭС", "Русгидро", "Россети", "Энел"])
    ]
    
    private static let cyclicalIndustries = ["МЕТАЛЛЫ"]
    
//    private static let trustworthyCompanies: [String] = ["Сегежа", "Алроса", "Яндекс", "Сбербанк", "АФК Система", "МТС", "Ростелеком", "Tinkoff","Норильский Никель", "Северсталь", "НЛМК", "ММК", "ВСМПО-Ависма","Группа ЛСР", "Эталон","Ozon", "Детский Мир", "X5 Retail Group", "Магнит"]
    
//    private static let untrustworthyCompanies = ["Аэрофлот", "ОАК", "НМТП"]
//    private static let exponentiallyGrowingCompanies = ["Яндекс", "Сбербанк", "МТС", "Ростелеком", "Tinkoff", "Медси", "Русгидро"]
    
    private static let holdings = ["AFKS", "RSTI", "RSTIP"]
}

extension CorporateConstants {
    
//    static func getTrustworthyCompanies() -> [String] {
//        return trustworthyCompanies
//    }
//
//    static func getUntrustworthyCompanies() -> [String] {
//        return untrustworthyCompanies
//    }
//
//    static func companyIsTrustWorthy(_ company: String) -> Bool? {
//        let containedInTrustworthyCompanies = trustworthyCompanies.contains(company)
//        let containedInUntrustworthyCompanies = untrustworthyCompanies.contains(company)
//
//        if containedInTrustworthyCompanies == false && containedInUntrustworthyCompanies == false { return nil }
//
//        return containedInTrustworthyCompanies
//    }
//
//    static func companyIsUntrustWorthy(_ company: String) -> Bool? {
//        let containedInTrustworthyCompanies = trustworthyCompanies.contains(company)
//        let containedInUntrustworthyCompanies = untrustworthyCompanies.contains(company)
//
//        if containedInTrustworthyCompanies == false && containedInUntrustworthyCompanies == false { return nil }
//
//        return containedInUntrustworthyCompanies
//    }
    
    static func isAHolding(_ company: String) -> Bool {
        return holdings.contains(company)
    }
    
    static func companyIsCyclical(_ targetCompany: String) -> Bool {
        for industry in industries {
            if cyclicalIndustries.contains(industry.name) { //Identifying a cyclical sector
                for company in industry.companies {
                    if company == targetCompany {
                        return true
                    }
                }
            }
        }
        return false
    }
    
//    static func marketSize(ofSector sector: String) -> Double? {
//        return marketSize[sector]
//    }
}

//MARK: - Charts
struct ChartConstants {
    
    static var maxChartBarWidth: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 100
        case .pad:
            return 100
        default:
            return 200
        }
    }
    
    static var maxChartHeight: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return UIScreen.main.bounds.height / 2.5
        case .pad:
            return UIScreen.main.bounds.height / 2.5
        default:
            return UIScreen.main.bounds.height
        }
    }
    
    
    static func numberOfChartsAllowedOnThisDevice() -> Int {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return 15
        case .pad: return 15
        case .unspecified: return 2
        default:
            return 10
        }
    }
}




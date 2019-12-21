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
        ("Авиа" , ["Аэрофлот", "ОАК"]),
        ("ГОСТИНИЦЫ" , ["Cosmos Group"]),
        ("ДЕРЕВООБРАБОТКА" , ["Сегежа"]),
        ("Драгоценные Камни" , ["Алроса"]),
        ("Инфраструктура", ["НМТП"]), //"ДВМП"
        ("ИТ" , ["РТИ", "Яндекс", "Сбербанк", "АФК Система", "МТС", "Ростелеком", "Tinkoff"]),
        ("МЕДИЦИНА" , ["Медси"]), //"Протек"
        ("МЕТАЛЛЫ" , ["Полюс Золото", "Норильский Никель", "Северсталь", "НЛМК", "ММК", "Русал", "ВСМПО-Ависма"]),
        ("НЕДВИЖИМОСТЬ" , ["Группа ЛСР", "Эталон"]),
        ("НЕФТЕГАЗ" , ["Новатэк", "Газпром", "Газпромнефть", "Лукойл", "Татнефть"]),
        ("РИТЕЙЛ" , ["Ozon", "Детский Мир", "X5 Retail Group", "Магнит"]),
        ("СЕЛЬСКОЕ ХОЗЯЙСТВО" , ["Степь", "Русагро"]),
        ("Удобрения" , ["Фосагро", "Акрон"]),
        ("ФИНАНСЫ" , ["Московская Биржа", "ВТБ"]),
        ("ЭЛЕКТРОЭНЕРГЕТИКА" , ["ФСК ЕЭС", "БЭСК",  "Русгидро", "Россети"]),
    ]
}

//MARK: - Charts
struct ChartConstants {
    
    static var maxChartBarWidth: CGFloat {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return 100
        case .pad:
            return 150
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
        case .phone: return 5
        case .pad: return 10
        case .unspecified: return 2
        default:
            return 10
        }
    }
}

//MARK: - Macro
struct MacroConstants {
    static let inflationRate = 4.0
    static let respectableGrowthRate = MacroConstants.inflationRate * 3
}

struct MonopolyConstants {
    let companies: [String] = ["ФСК ЕЭС", "Газпром", "НМТП", "Яндекс", "Татнефть"]
}

//
//  C.swift
//  Compound 2
//
//  Created by Robert Zakiev on 17.04.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

///Houses all constants in the app
struct C {
    //MARK: - Directory
    static let userDataDirectory = "User Resources/"
    static let corporateDataDirectory = "CorporateResources/"
    
    ///Variables related to the investment ideas upside view
    struct UpsidesVariables {
        static let upsidesDirectory = "/OtherResources/Upsides/"
    }
}

//MARK: Macro constants
extension C {
    ///Macro constants
    struct Macro {
        //MARK: - Inflation
        static let inflationRate = 4.0
        static let respectableGrowthRate = inflationRate * 3
        
        //MARK: - GDP
        ///in USD
        static let GDPOfWorld = 83_300_000_000_000.0
        ///in RUB
        static let GDPofRussia = 109_361_500_000_000.0
        
        //MARK: - Population
        static let worldPopulation: Int = 7_827_822_368
        static let populationOfRussia: Int = 145_956_611
        
        //MARK: - GDP Per Capita
        static var worldGDPPerCapitaPerMonth: Double { GDPOfWorld / Double(worldPopulation) / 12 }
        static var russiaGDPPerCapitaPerMonth: Double { GDPofRussia / Double(populationOfRussia) / 12 }
        
        //MARK: - Interest Rates
        static let interestRateInRussia = 4.25
        static var interestRateYield: Double { 100 / interestRateInRussia }
    }
}

extension C {
    struct Tickers {
        private static let tickerSymbols: [String: String] = [
            "GMKN" : "Норильский Никель",
            "YNDX" : "Яндекс",
            "RTKM" : "Ростелеком",
            "FIVE" : "X5 Retail Group",
            "TCSG" : "Tinkoff",
            "LSRG" : "Группа ЛСР",
            "VSMO" : "ВСМПО-Ависма",
            "CHMF" : "Северсталь",
            "RTKMP" : "Ростелеком-п",
            "AGRO" : "Русагро",
            "ENRU" : "Энел",
            "SBERP" : "Сбербанк-п",
            "SBER" : "Сбербанк",
            "MGNT" : "Магнит",
            "VTBR" : "ВТБ",
            "HYDR" : "Русгидро",
            "NMTP" : "НМТП",
            "DSKY" : "Детский Мир",
            "AFKS" : "АФК Система",
            "NLMK" : "НЛМК",
            "UNAC" : "ОАК",
            "AFLT" : "Аэрофлот",
            "RUAL" : "Русал",
            "FEES" : "ФСК ЕЭС",
            "ETLN" : "Эталон",
            "MOEX" : "Московская Биржа",
            "MAGN" : "ММК",
            "MTSS" : "МТС",
            "FLOT" : "Совкомфлот",
            "SMLT" : "Самолёт",
            "GLTR" : "Глобалтранс",
            "IRAO" : "ИнтерРао",
            "BSPB" : "Банк Санкт-Петербург",
            "LSNGP" : "Ленэнерго-п",
            "LNTA" : "Лента",
            "MDMG" : "Мать и Дитя",
            "GAZP" : "Газпром",
            "SGZH" : "Сегежа"
        ]
        
        //    static let companiesWithPreferredShares = allTickerSymbols().filter({ $0.suffix(1) == "P" }).filter({$0.count == 5})
        static let companiesWithPreferredShares = ["SBERP", "RTKMP"]
        
        ///Returns a beautiful name of the company whose ticker symbol is provided
        static func companyName(for ticker: String) -> String? {
            return tickerSymbols[ticker]
        }
        
        static func ticker(for company: String) -> String? {
            return  tickerSymbols.someKey(forValue: company)
        }
        
        static func allTickerSymbols() -> [String] {
            return tickerSymbols.map(\.key)
        }
        
        static func allTickerSymbolsWithNames() -> [String:String] {
            return tickerSymbols
        }
        
        static func allTickerSymbolsWithNames() -> [CompanyName] {
            return allTickerSymbolsWithNames().map({ CompanyName(name: $0.value , ticker: $0.key) })
        }
        
        static func preferredShareTicker(for ticker: String) -> String {
            return ticker + "P"
        }
    }
}

//MARK: - ChartView constants
extension C {
    ///Constants for the chart view
    struct Chart {
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
                return UIScreen.main.bounds.height / 2.5
            }
        }
        
        static func numberOfChartsAllowedOnThisDevice() -> Int {
            switch UIDevice.current.userInterfaceIdiom {
            case .phone: return 50
            case .pad, .mac: return 50
            case .unspecified: return 50
            default:
                return 50
            }
        }
    }
}

//MARK: - API Keys
extension C {
    struct PolygonAPI {
        static let key = "kATfwcnbHHRPIxQgOKRF0iFYT0hWx62i"
    }
}

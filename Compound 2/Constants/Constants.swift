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
    static let userDataDirectory = "/User Resources/"
    static let corporateDataDirectory = "CorporateResources/"
    
    ///Variables related to the investment ideas upside view
    struct UpsidesVariables {
        static let upsidesDirectory = "/OtherResources/Upsides/"
    }
    
    struct PortfolioReturnsVariables {
        static let returnDirectory = C.userDataDirectory + "PortfolioReturns/"
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

//MARK: - Tickers
extension C {
    struct Tickers {
        //MARK: - Russian tickers
        private static let russianTickerSymbols: [String: String] = [
            "GMKN" : "Норильский Никель",
            "YNDX" : "Яндекс",
            "RTKM" : "Ростелеком",
            "FIVE" : "X5 Retail Group",
            "TCSG" : "Tinkoff",
            "LSRG" : "Группа ЛСР",
            "VSMO" : "ВСМПО-Ависма",
            "CHMF" : "Северсталь",
            "RTKMP" : "Ростелеком-п",
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
            "SGZH" : "Сегежа",
            "GEMC" : "ЕМС",
            "CIAN": "Циан",
            "HHRU": "HeadHunter",
            "MAIL": "VK",
            "OKEY": "Окей",
            "OZON": "Ozon",
            "SFTL": "Softline"
        ]
        
        ///Returns a beautiful name of the Russian company whose ticker symbol is provided
        static func companyName(for ticker: String) -> String? {
            return russianTickerSymbols[ticker]
        }
        
        static func ticker(for company: String) -> String? {
            return  russianTickerSymbols.someKey(forValue: company)
        }
        
        static func allTickerSymbols() -> [String] {
            return russianTickerSymbols.map(\.key)
        }
        
        static func allTickerSymbolsWithNames() -> [String:String] {
            return russianTickerSymbols.merging(foreignTickerSymbols, uniquingKeysWith: { (key1, key2) in key1 })
        }
        
        static func allTickerSymbolsWithNames() -> [CompanyName] {
            return allTickerSymbolsWithNames().map({ CompanyName(name: $0.value , ticker: $0.key) })
        }
        
        //MARK: - Foreign tickers
        private static let foreignTickerSymbols: [String: String] = [
            "PBF" : "PBF Energy",
            "BIDU" : "Baidu",
            "KO" : "Coca-Cola",
            "AMZN" : "Amazon"
        ]
        
        static func allForeignTickerSymbols() -> [String] {
            return foreignTickerSymbols.map(\.key)
        }
        
        private static let tickersSortedByIndustry = [
            "Авиалинии": ["AFLT"],
            "Банки": ["BSPB", "VTBR", "SBER", "TCSG"],
            "IT": ["YNDX", "MTSS", "RTKM"],
            "Деревообработка": ["SGZH"],
            "Нефтегаз": ["GAZP", "ROSN", "LKOH", "SIBN", "BANE"],
            "Медицина": ["GEMC", "MDMG"],
            "Девелопмент": ["ETLN"]
            
        ]
        
        static func securityGeography(for ticker: String) -> SecurityGeography {
            if russianTickerSymbols[ticker] != nil { return .russia }
            
            if foreignTickerSymbols[ticker] != nil { return .foreign }
            
            return .unknown
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
        static let baseURL = "https://api.polygon.io/v2/"
        
        ///The directory where Polygon data ought to be stored
        static let dataDirectory = "PolygonData/"
        ///The sub-directory where companies' financial data ought to be stored
        static let financialDataDirectory = dataDirectory + "FinancialData/"
    }
    
    struct AlphaVantageAPI {
        ///API key that authorizes the app to use Alpha Vantage API
        static let key = "0744SVCZC3OLQYV8"
    }
}

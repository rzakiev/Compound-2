//
//  ConstantTickerSymbols.swift
//  Compound 2
//
//  Created by Robert Zakiev on 02.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct ConstantTickerSymbols {
     private static let tickerSymbols: [String: String] = [
        "GMKN" : "Норильский Никель",
        "RSTI" : "Россети",
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
        "RSTIP" : "Россети-п",
        "FEES" : "ФСК ЕЭС",
        "ETLN" : "Эталон",
        "MOEX" : "Московская Биржа",
        "MAGN" : "ММК",
        "MTSS" : "МТС",
    ]
    
    static let companiesWithPreferredShares = allCompaniesWithTicker().filter({ $0.suffix(2) == "-п" }).map({ String($0.dropLast(2)) })
    
    static func company(for ticker: String) -> String? {
        return tickerSymbols[ticker]
    }
    
    static func ticker(for company: String) -> String? {
        return  tickerSymbols.someKey(forValue: company)
    }
    
    static func allCompaniesWithTicker() -> [String] {
        return tickerSymbols.map(\.value)
    }
    
    static func allTickerSymbols() -> [String] {
        return tickerSymbols.map(\.key)
    }
    
    static func preferredShareTicker(for ticker: String) -> String {
        return ticker + "P"
    }
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

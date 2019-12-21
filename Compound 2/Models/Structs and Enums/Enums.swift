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

enum Indicator: String {
    case undefined
    case revenue = "Выручка"
    case OIBDA = "OIBDA"
    case EBITDA = "EBITDA"
    case netProfit = "Чистая прибыль"
    case freeCashFlow = "Свободный денежный поток"
    case debtToEBITDA = "Долг / EBITDA"
    case dividend = "Дивиденды"
    case commissionIncome = "Комиссионные Доходы"
    case interestIncome = "Процентные Доходы"
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

enum Multiplier {
    case priceToEarnings
    case EVtoEBITDA
    case dividendYield
}

//MARK: - Invesments
enum InvestmentType: String { //: CaseIterable
    case undefined
    case dividendPlay = "Рассчитываю на дивиденды" //Investment case in which an investor expects decent dividends from the company
    case growthPlay = "Считаю, что компания будет расти" //Investment case in which an investor expects the company to appreciably grow
    //case ecosystemPlay //Investment case in which an investor expects the company to leverage its ecosystems to acheive above-average growth
    //case monopoly //Investment case that rests on the company's moat that will enable it to preserver its market share and maintains its income and dividends
    case technicalAnalysis = "Хочу купить акции исходя из технического анализа"
}

enum ReasonToInvest: String {
    case undefined
    case businessIsOperatingInGrowingIndustry
    case businessIsCAPEXLight
    case managementIsLoyalToShareholders
}

//MARK: - Preferences
enum CompanyInfoSegment: String, CaseIterable {
    case finances = "Финансы"
    case production = "Производство"
    case ecosystem = "Экосистема"
    case tradingView = "Trading View"
}











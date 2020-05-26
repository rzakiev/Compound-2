//
//  File.swift
//  Compound 2
//
//  Created by Robert Zakiev on 04.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation



struct RiskAnalysisVerdict {
    let verdict: String
    let risksToConsider: [InvestmentRisk]
    let riskScore: Int
}

///Contains methods for analyzing risks
struct RiskAnalysis {
    ///Only static methids in this struct
    @available(*, unavailable)
    init() {  }
    
    static func compareRisksInTwoCompanies(companyA: String, companyB: String) -> (firstCompanyVerdict: RiskAnalysisVerdict, secondCompanyVerdict: RiskAnalysisVerdict) {
        let firstCompanyVerdict = analyzeAllRisks(inCompany: companyA)
        let secondCompanyVerdict = analyzeAllRisks(inCompany: companyB)
        return (firstCompanyVerdict, secondCompanyVerdict)
    }
    
    static func analyzeAllRisks(inCompany company: String) -> RiskAnalysisVerdict {
        
        var verdict = ""
        var risks = [InvestmentRisk]()
        
//        if let analysis = companyHasHorrificManagement(company), analysis == true {
//            verdict += "У компании ужасный менеджмент.\n"
//            risks.append(.horrificManagement)
//        }
        
        if companyIsCyclical(company) {
            verdict += "Компания работает в цикличном секторе, что делает её финансовые показатели непредсказуемыми.\n"
            risks.append(.cyclicalIndustry)
        }
        
        if let dividendAnalysis = companyMaySuspendDividendPayments(company) {
            verdict += dividendAnalysis
            risks.append(.maySuspendDividends)
        }

        let riskSkore = risks.map({ $0.riskValue }).reduce(0, +)
        return .init(verdict: verdict, risksToConsider: risks, riskScore: riskSkore)
    }
}
///Methods for assessing individual risks
extension RiskAnalysis {
//    static func companyHasHorrificManagement(_ company: String) -> Bool? {
//        if let isUntrustworthy = CorporateConstants.companyIsUntrustWorthy(company) { return isUntrustworthy }
//        else { return nil }
//    }
    
    static func companyIsCyclical(_ company: String) -> Bool {
        return CorporateConstants.companyIsCyclical(company)
    }
    
    static func companyMaySuspendDividendPayments(_ companyName: String) -> String? {
        
        var dividendSuspensionReason = ""
        
        if CorporateConstants.companyIsCyclical(companyName) {
            dividendSuspensionReason += "Посколько компания работает в цикличном секторе, её дивиденды могут снизиться во время прохождения дна цикла.\n"
        }
        
        let company = Company(name: companyName)
        let dividendDeclineInLastFiveYears = company.chartValues(for: .dividend)!.first(where: { (growthValue) -> Bool in
            if growthValue.growth == nil { return false }
            else {
                if growthValue.growth! <= -40 { return true } //Dividend is considered declined if the decrease was at least 50 percent
                else { return false }
            }
        })
        
        if let dividendSuspensions = company.dividends?.filter({ $0.value < 0.1 }) {
            dividendSuspensionReason += "В "
            for i in 0..<dividendSuspensions.count {
                if i != dividendSuspensions.count - 1 {
                    dividendSuspensionReason += String(dividendSuspensions[i].year) + ", "
                } else {
                    dividendSuspensionReason = String(dividendSuspensionReason.dropLast(2))
                    dividendSuspensionReason += "и в " + String(dividendSuspensions[i].year) + " годах компания вовсе приостановила дивиденды, то есть отношение к миноритарным акционерам осталвяет желать лучшего.\n"
                }
            }
        }
        
        if dividendDeclineInLastFiveYears != nil { dividendSuspensionReason += "Кроме того, компания снижала дивиденды в \(dividendDeclineInLastFiveYears!.year) году на \(dividendDeclineInLastFiveYears!.growth!) %. Следует быть осторожным.\n" }
        
        return dividendSuspensionReason == "" ? nil: dividendSuspensionReason
    }
    
    ///Returns analysis as to whether the company may grow in the future
    private static func companyIsUnlikelyToGrow(_ company: String) -> String? {
        return ""
    }
}

//
//  Investment.swift
//  Compound 2
//
//  Created by Robert Zakiev on 04.11.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

enum CashFlowType {
    case variable
    case stable
//    case growing
}

struct InvestmentCase: Investment {
    
    let type: InvestmentType
    
    let company: String
    
    let cashFlowType: CashFlowType
    
    init(company: String, type: InvestmentType) {
        self.type = type
        self.company = company
        
        if CorporateConstants.companyIsCyclical(company) {
            self.cashFlowType = .variable
        } else {
            self.cashFlowType = .stable
        }
    }
    
    func checkInvestmentThesis() -> InvestmentVerdict {
        switch type {
        case .growthPlay:
            return checkIfCompanyIsGrowthPlay(company)
        case .dividendPlay:
            return checkIfCompanyIsDividendPlay(company)
        default:
            return InvestmentVerdict(isGoodInvestment: false, analysis: "Неизвестный тип инвестиций")
        }
    }
}

//MARK: - Checking if the company can be considered a growth story
private extension InvestmentCase {
    
    func checkIfCompanyIsGrowthPlay(_ company: String) -> InvestmentVerdict {
        let revenueGrowthRate = Statistics.getRevenueCAGR(for: company) * 100
        
        if revenueGrowthRate > ConstantsMacro.respectableGrowthRate {
            return InvestmentVerdict(isGoodInvestment: true,
                                     analysis: "Да, \(company) можно назвать растущей компанией: средний темп прироста выручки за последние 5 лет составляет \(revenueGrowthRate)%")
        } else {
            return InvestmentVerdict(isGoodInvestment: false,
                                     analysis: "Компанию \(company) сложно назвать растущей: средний темп прироста выручки за последние 5 лет составляет \(revenueGrowthRate)%, в то время как уровень инфляции за этот же период составил \(ConstantsMacro.inflationRate)%")
        }
    }
}

//MARK: - Checking if the company can be considered a dividend play
private extension InvestmentCase {
    func checkIfCompanyIsDividendPlay(_ company: String) -> InvestmentVerdict {
        
        let company = Company(name: company)
        
        //If there are no dividends paid out, the company is definitely not a dividend player
        guard let dividends = company.dividends else {
            return InvestmentVerdict(isGoodInvestment: false,
                                     analysis: "Компания \(company.name) не выплачивала дивиденды за последние 5 лет, поэтому рассматривать ее в качестве дивидендной истории сложно")
        }
        
        //Looking for companies who have paid out no dividends
        if dividends.first(where: {$0.value > 0}) == nil {
            return InvestmentVerdict(isGoodInvestment: false,
                                     analysis: "Компания \(company.name) не выплачивала дивиденды за последние 5 лет, поэтому рассматривать ее в качестве дивидендной истории сложно")
        }
        
        let suspendedDividendsInLastFiveYears = dividendsWereSuspended(dividends: dividends)
        
        let dividendsDidDeclineInLastFiveYears = dividendsDidDecline(company: company)
        
        
        
        if suspendedDividendsInLastFiveYears.suspended && dividendsDidDeclineInLastFiveYears.declined {
            return InvestmentVerdict(isGoodInvestment: false,
                                     analysis: "Компания не выплачивала дивиденды в \(suspendedDividendsInLastFiveYears.year) году. Помимо этого, дивиденды в \(dividendsDidDeclineInLastFiveYears.year) году были снижены, поэтому рассматривать компанию \(company.name) в качестве дивидендной истории точно не стоит")
        } else if suspendedDividendsInLastFiveYears.suspended {
            return InvestmentVerdict(isGoodInvestment: false,
                              analysis: "Компания не выплачивала дивиденды в \(suspendedDividendsInLastFiveYears.year) году, поэтому рассматривать компанию \(company.name) в качестве дивидендной истории не стоит.")
            
        } else if dividendsDidDeclineInLastFiveYears.declined {
            return InvestmentVerdict(isGoodInvestment: false,
                                     analysis: "Дивиденды в \(dividendsDidDeclineInLastFiveYears.year) году были снижены, поэтому рассматривать компанию \(company.name) в качестве дивидендной истории стоит с повышенной осторожностью")
        } else {
            return InvestmentVerdict(isGoodInvestment: true,
                                     analysis: "Компания \(company.name) является достойным кандидатом для дивидендного портфеля!")
        }
    }
    
    //Utility function that determines if a company's dividends declined in the last five years
    func dividendsDidDecline (company: Company) -> (declined: Bool, year: Int) {
        //Finding out if
        //let maximumDividendInFiveYears = company.dividends!.max(by: { $0.value > $1.value })!.value
        //let minimumDividendInFiveYears = company.dividends!.min(by: { $0.value > $1.value })!.value
        
        let dividendsDidDeclineInLastFiveYears = company.chartValues(for: .dividend)!.first(where: { (growthValue) -> Bool in
            if growthValue.growth == nil { return false }
            else {
                if growthValue.growth! < -10 { return true } //Dividend is considered declined if the decrease was at least 5 percent
                else { return false }
            }
        })
        
        if dividendsDidDeclineInLastFiveYears != nil {
            return (true, dividendsDidDeclineInLastFiveYears!.year)
        } else {
            return (false, -1)
        }
    }
    
    func dividendsWereSuspended (dividends: [(year: Int, value: Double)]) -> (suspended: Bool, year: Int) {
        if let dividendSuspensionYear = dividends.suffix(5).first(where: { $0.value == 0 })?.year {
            return (true, dividendSuspensionYear)
        } else {
            return (false, -1)
        }
    }
}


//Compare two investments at the current moment
extension InvestmentCase {
    ///Use this method to compare two companies and decide which one is the best long-term investment
    static func compareTwoCompanies(companyA: String, companyB: String) -> String {
//        let companyA = Company(name: companyA)
//        let companyB = Company(name: companyB)
//        let exponentialComparison = compareCompaniesByExponentialGrowth(companyA: companyA, companyB: companyB)
//        if exponentialComparison.canBeCompared == true { return exponentialComparison.analysis }
        
        
        
        return "Error"
    }
    
//    static func compareCompaniesByExponentialGrowth(companyA: String, companyB: String) -> InvestmentComparison {
//        if CorporateConstants.exponentiallyGrowingCompanies.contains(companyA) {
//            return .init(canBeCompared: true, analysis: "Компания \(companyA) является экспоненциально растущей, лучше купить её")
//        } else if CorporateConstants.exponentiallyGrowingCompanies.contains(companyB) {
//        return .init(canBeCompared: true, analysis: "Компания \(companyB) является экспоненциально растущей, лучше купить её")
//        }
//        else {
//            return .init(canBeCompared: false, analysis: "Uncomparable")
//        }
//    }
}

extension InvestmentCase {
    
    ///Synchronously calculates the investment return for a specific company
    static func calculateInvestmentReturn(for company: String, projectedDividends: [(year: Int, dividend: Double)]) -> Double? {
        var _: Double = 0
        
        guard let _ = try? FinancialDataManager.getSmartlabLinks()[company] else {
            Logger.log(error: "Attempting to calculate an investment return for a private company")
            return nil
        }
        
//        let quote = QuoteService.shared.allQuotes.first(where: {$0.companyName == company}) ?? QuoteService.getQuote(for: company)
//        let _ = MarketCapitalization.calculateMarketCapitalization(for: company, quote: (quote.ordinaryShareQuote, quote.preferredShareQuote))
        
        for _ in projectedDividends {
            
        }
        
        return 3
    }
}



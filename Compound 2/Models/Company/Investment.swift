//
//  Investment.swift
//  Compound 2
//
//  Created by Robert Zakiev on 04.11.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

struct Investment {
    
    let type: InvestmentType
    
    private let name: String
    
    init(company: String, type: InvestmentType) {
        self.type = type
        self.name = company
    }
    
    func checkInvestmentThesis() -> InvestmentVerdict {
        switch type {
        case .growthPlay:
            return checkIfCompanyIsGrowthPlay(name)
        case .dividendPlay:
            return checkIfCompanyIsDividendPlay(name)
        case .technicalAnalysis:
            return checkIfCompanyCanBeBoughtBasedOnTechnicalAnalysis(name)
        default:
            return InvestmentVerdict(isGoodInvestment: false, analysis: "Неизвестный тип инвестиций")
        }
    }
}

//MARK: - Checking if the company can be considered a growth story
private extension Investment {
    
    func checkIfCompanyIsGrowthPlay(_ company: String) -> InvestmentVerdict {
        let revenueGrowthRate = Statistics.getRevenueCAGR(for: company) * 100
        
        if revenueGrowthRate > MacroConstants.respectableGrowthRate {
            return InvestmentVerdict(isGoodInvestment: true,
                                     analysis: "Да, \(company) можно назвать растущей компанией: средний темп прироста выручки за последние 5 лет составляет \(revenueGrowthRate)%")
        } else {
            return InvestmentVerdict(isGoodInvestment: false,
                                     analysis: "Компанию \(company) сложно назвать растущей: средний темп прироста выручки за последние 5 лет составляет \(revenueGrowthRate)%, в то время как уровень инфляции за этот же период составил \(MacroConstants.inflationRate)%")
        }
    }
}

//MARK: - Checking if the company can be considered a dividend play
private extension Investment {
    func checkIfCompanyIsDividendPlay(_ company: String) -> InvestmentVerdict {
        
        let company = Company(name: company)
        
        //If there are no dividends paid out, the company is definitely not a dividend player
        guard let dividends = company.dividends else {
            return InvestmentVerdict(isGoodInvestment: false,
                                     analysis: "Компания \(name) не выплачивала дивиденды за последние 5 лет, поэтому рассматривать ее в качестве дивидендной истории сложно")
        }
        
        //Looking for companies who have paid out no dividends
        if dividends.first(where: {$0.value > 0}) == nil {
            return InvestmentVerdict(isGoodInvestment: false,
                                     analysis: "Компания \(name) не выплачивала дивиденды за последние 5 лет, поэтому рассматривать ее в качестве дивидендной истории сложно")
        }
        
        let suspendedDividendsInLastFiveYears = dividendsWereSuspended(dividends: dividends)
        
        let dividendsDidDeclineInLastFiveYears = dividendsDidDecline(company: company)
        
        
        
        if suspendedDividendsInLastFiveYears.suspended && dividendsDidDeclineInLastFiveYears.declined {
            return InvestmentVerdict(isGoodInvestment: false,
                                     analysis: "Компания не выплачивала дивиденды в \(suspendedDividendsInLastFiveYears.year) году. Помимо этого, дивиденды в \(dividendsDidDeclineInLastFiveYears.year) году были снижены, поэтому рассматривать компанию \(name) в качестве дивидендной истории точно не стоит")
        } else if suspendedDividendsInLastFiveYears.suspended {
            return InvestmentVerdict(isGoodInvestment: false,
                              analysis: "Компания не выплачивала дивиденды в \(suspendedDividendsInLastFiveYears.year) году, поэтому рассматривать компанию \(name) в качестве дивидендной истории не стоит.")
            
        } else if dividendsDidDeclineInLastFiveYears.declined {
            return InvestmentVerdict(isGoodInvestment: false,
                                     analysis: "Дивиденды в \(dividendsDidDeclineInLastFiveYears.year) году были снижены, поэтому рассматривать компанию \(name) в качестве дивидендной истории стоит с повышенной осторожностью")
        } else {
            return InvestmentVerdict(isGoodInvestment: true,
                                     analysis: "Компания \(name) является достойным кандидатом для дивидендного портфеля!")
        }
    }
    
    //Utility function that determines if a company's dividends declined in the last five years
    func dividendsDidDecline (company: Company) -> (declined: Bool, year: Int) {
        //Finding out if
        //let maximumDividendInFiveYears = company.dividends!.max(by: { $0.value > $1.value })!.value
        //let minimumDividendInFiveYears = company.dividends!.min(by: { $0.value > $1.value })!.value
        
        let dividendsDidDeclineInLastFiveYears = company.growthRate(for: .dividend)!.first(where: { (growthValue) -> Bool in
            if growthValue.growth == nil { return false }
            else {
                if growthValue.growth! < -5 { return true } //Dividend is considered declined if the decrease was at least 5 percent
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
        if let dividendSuspension = dividends.suffix(5).first(where: { $0.value == 0 })?.year {
            return (true, dividendSuspension)
        } else {
            return (false, -1)
        }
    }
}

//Mark: - Technical Analysis
private extension Investment {
    
    func checkIfCompanyCanBeBoughtBasedOnTechnicalAnalysis(_ company: String) -> InvestmentVerdict {
        return InvestmentVerdict(isGoodInvestment: false,
                     analysis: "-__________________-")
    }
    
//    func checkIfCompanyIsMonopoly(_ company: String) -> InvestmentVerdict {
//        return InvestmentVerdict(isGoodInvestment: false,
//                                 analysis: "Компанию сложно назвать растущей: средний темп прироста выручки за последние 5 лет составляет \(3)%")
//    }
//
//    func checkIfCompanyIsEcosystem(_ company: String) -> InvestmentVerdict {
//        return InvestmentVerdict(isGoodInvestment: false,
//                                 analysis: "Компанию сложно назвать растущей: средний темп прироста выручки за последние 5 лет составляет \(3)%")
//    }
}

//
//  QuoteService.swift
//  Compound 2
//
//  Created by Robert Zakiev on 05/09/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

struct QuoteService {
    
    static let shared = QuoteService()
    
    init() {
        Logger.log(operation: "Initializing the shared instance of the Quote Service")
    }
    
    //Use this method to fetch a quote synchronously
    public func getQuote(for company: String) -> (ordinarySharePrice: Double?, preferredSharePrice: Double?) {
        
        guard let smartlabLink = try? FinancialDataManager.getSmartlabLinks()[company] else {
            Logger.log(error: "No smartlab link for the specified company")
            return (nil, nil)
        }
        
        return getQuoteFromSmartlabPage(link: smartlabLink)
    }
    
    public func asynchronouslyGetQuote(for company: String, completion: ((Double?, Double?) -> Void)?) {
        
        DispatchQueue.main.async {
        
            guard let smartlabLink = try? FinancialDataManager.getSmartlabLinks()[company] else {
                Logger.log(error: "No smartlab link for the specified company")
                return
            }
            
            let quote = self.getQuoteFromSmartlabPage(link: smartlabLink)
            
            completion?(quote.ordinarySharePrice, quote.preferredSharePrice)
        }
    }
}

//MARK: - Fetching Quotes
extension QuoteService {
    private func getQuoteFromSmartlabPage(link: String) -> (ordinarySharePrice: Double?, preferredSharePrice: Double?) {
        
        let url = URL(string: link)
        let pageContent: String? = try? String(contentsOf: url!, encoding: .utf8)
        
        if pageContent != nil {
            let filterText = "<span class=\"temp_micex_info_item\">" //This tag contains the quote
            
            //Finding the first instance of the <span class=\"temp_micex_info_item\">. This tag should contain the price of the ordinary share
            if let openSpanRange = pageContent!.range(of: filterText)  {
                let firstIrange = pageContent![openSpanRange.upperBound...]
                if let openingIRange = firstIrange.range(of: "<i>"), let closingIrange = firstIrange.range(of: "</i>") {
                    let priceString = String(pageContent![openingIRange.upperBound..<closingIrange.lowerBound]).dropLast(1)
                    let ordinarySharePrice: Double? = Double(priceString) ?? nil
                    
                    if let secondOpeningSpanRange = pageContent![closingIrange.upperBound...].range(of: filterText) { //Looking for the preferred share quote
                        let secondIrange = pageContent![secondOpeningSpanRange.upperBound...]
                        if let openingIRange = secondIrange.range(of: "<i>"), let closingIrange = secondIrange.range(of: "</i>") {
                            let priceString = String(pageContent![openingIRange.upperBound..<closingIrange.lowerBound]).dropLast(1)
                            let preferreSharePrice: Double? = Double(priceString) ?? nil
                            return (ordinarySharePrice, preferreSharePrice)
                        }
                    } else {
                        Logger.log(error: "Fetched the ordinary share price but couldn't fetch the preferred share price")
                        return (ordinarySharePrice, nil)
                    }
                }
            } else {
                Logger.log(error: "Couldn't fetch the HTML tag containing the price of the security")
                return (nil, nil)
            }
        }
        return (nil, nil)
    }
}

//MARK: - Market Capitalization Calculation
extension QuoteService {
    
    func fetchMarketCapitalization(for company: String) -> Double? {
        
        if let quoteSource = try? FinancialDataManager.getSmartlabLinks()[company] {
           
            let quotes = getQuoteFromSmartlabPage(link: quoteSource)
                
            if let shares = try? FinancialDataManager.numberOfSharesFor(company: company),
                let ordinaryQuote = quotes.ordinarySharePrice {
                
                //if the company has both ordinary and preferred shares
                if let preferredShares = shares.numberOfPreferredShares, let preferredQuote = quotes.preferredSharePrice {
                    return Double(shares.numberOfOrdinaryShares) * ordinaryQuote + Double(preferredShares) * preferredQuote
//                    completion(marketCap) //returing the fetched market cap back to the closure
                } else { //If the company has only oridnary shares
                    return Double(shares.numberOfOrdinaryShares) * ordinaryQuote //calculating the market capitalization
//                    completion(marketCap) //returing the fetched market cap back to the closure
                }
            }
        }
        return nil
    }
}

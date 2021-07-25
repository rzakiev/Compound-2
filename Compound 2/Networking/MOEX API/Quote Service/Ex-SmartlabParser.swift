//
//  Ex-SmartlabParser.swift
//  Compound 2
//
//  Created by Robert Zakiev on 16.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

//MARK: - Fetching Quotes From Smartlab
extension MoexQuoteService {
    private func getAQuoteFromSmartlabPage(link: String) -> (ordinarySharePrice: Double?, preferredSharePrice: Double?) {

        guard let url = URL(string: link) else { return (nil, nil) }
        guard let pageContent = try? String(contentsOf: url, encoding: .utf8) else { return (nil, nil) }

        let filterText = "<span class=\"temp_micex_info_item\">" //This tag contains the quote

        //Finding the first instance of the <span class=\"temp_micex_info_item\">. This tag should contain the price of the ordinary share
        if let openSpanRange = pageContent.range(of: filterText)  {
            let firstIrange = pageContent[openSpanRange.upperBound...]
            if let openingIRange = firstIrange.range(of: "<i>"), let closingIrange = firstIrange.range(of: "</i>") {
                let priceString = String(pageContent[openingIRange.upperBound..<closingIrange.lowerBound]).dropLast(1)
                let ordinarySharePrice: Double? = Double(priceString) ?? nil

                if let secondOpeningSpanRange = pageContent[closingIrange.upperBound...].range(of: filterText) { //Looking for the preferred share quote
                    let secondIrange = pageContent[secondOpeningSpanRange.upperBound...]
                    if let openingIRange = secondIrange.range(of: "<i>"), let closingIrange = secondIrange.range(of: "</i>") {
                        let priceString = String(pageContent[openingIRange.upperBound..<closingIrange.lowerBound]).dropLast(1)
                        let preferreSharePrice: Double? = Double(priceString) ?? nil
                        return (ordinarySharePrice, preferreSharePrice)
                    }
                } else {
//                    Logger.log(warning: "Fetched the ordinary share price but couldn't fetch the preferred share price")
                    return (ordinarySharePrice, nil)
                }
            }
        } else {
            Logger.log(error: "Couldn't fetch the HTML tag containing the price of the security from: \(link)")
            return (nil, nil)
        }
        return (nil, nil)
    }
}

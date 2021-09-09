//
//  IdeasUpsideDataProvider.swift
//  Compound 2
//
//  Created by Robert Zakiev on 17.04.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation
import Combine

final class IdeasUpsideDataProvider: ObservableObject {
    
    let fileName: (name: String, format: String)
    
    @Published var ideas: InvestmentIdeas
    
    private var quoteSubscriber: AnyCancellable?
    
    init(fileName: (name: String, format: String)) {
        
        self.fileName = fileName
        
        guard let jsonPath = Bundle.main.path(forResource: fileName.name, ofType: fileName.format, inDirectory: C.UpsidesVariables.upsidesDirectory) else {
            ideas = .init(author: "N/A", values: [])
            Logger.log(error: "No path for \(fileName)")
            return
        }
        
        guard let localIdeasData = FileManager.default.contents(atPath: jsonPath) else {
            Logger.log(error: "No malishok's investment ideas file")
            ideas = .init(author: "N/A", values: [])
            return
        }
        
        guard let decodedIdeas = try? JSONDecoder().decode(InvestmentIdeas.self, from: localIdeasData) else {
            Logger.log(error: "Unable to decode the malishok's investment ideas file")
            ideas = .init(author: "N/A", values: [])
            return
        }
        
        let expiredIdeas: [String]
        if fileName.name == "Malishok" {
            expiredIdeas = ["VLO", "MPC", "MRO", "RIG", "AR", "BTU", "CLR", "DVN", "ET", "HNRG", "LPI", "PHX", "ALRS"]
        } else {
            expiredIdeas = []
        }
        
        //Removing expired ideas from the list
        let filteredIdeas = decodedIdeas.values.filter({ !expiredIdeas.contains($0.ticker) })
        
        ideas = InvestmentIdeas(author: decodedIdeas.author, values: filteredIdeas)
        
        quoteSubscriber = YahooQuoteService.shared.$allQuotes.receive(on: DispatchQueue.main).sink(receiveValue: { [unowned self] (_) in
            for i in 0..<self.ideas.values.count {
                guard let quote = findQuote(for: i) else { continue }
                ideas.values[i].updateUpside(currentQuote: quote)
            }
        })
    }
}

extension IdeasUpsideDataProvider {
    func findQuote(for i: Int) -> SimpleQuote? {
        return YahooQuoteService.shared.allQuotes.first(where: { $0.ticker == self.ideas.values[i].ticker }) ?? MoexQuoteService.shared.allQuotes.first(where: { $0.ticker == self.ideas.values[i].ticker }) ?? nil
    }
}

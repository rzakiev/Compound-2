//
//  PolygonAPI.swift
//  Compound 2
//
//  Created by Robert Zakiev on 06.07.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation

struct PolygonAPI {
    @available(*, unavailable)
    fileprivate init() { Logger.log(error: "Initializaing an instance of \(Self.self)") }
}

extension PolygonAPI {
    @discardableResult
    static func fetchHistoricalFinancialData(for ticker: String) async {
        
    }
}

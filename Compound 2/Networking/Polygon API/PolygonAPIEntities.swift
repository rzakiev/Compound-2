//
//  PolygonAPIEntities.swift
//  PolygonAPIEntities
//
//  Created by Robert Zakiev on 31.07.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation

///Houses financial data for some company retrieved via API
struct PolygonData: Codable, FinancialData {
    let ticker: String
    let values: [String : [FinancialFigure]]
}

extension PolygonDataService {
    enum TimeFrame: String {
        case annual
        case quarterly
    }
}

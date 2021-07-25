//
//  PieChartColorGenerator.swift
//  Compound 2
//
//  Created by Robert Zakiev on 24.06.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct PieChartColorGenerator {
    
    static func generateColor(forTicker ticker: String) -> Color? {
        return preferredColors[ticker] ?? Color.blue
    }
    
}


extension PieChartColorGenerator {
    private static var preferredColors: [String: Color] = [
        "SBER" : .green,
        "SBERP" : .green,
        "MTSS" : .red,
        "RTKM" : Color(red: 119, green: 37, blue: 251),
        "RTKMP" : .blue,
        "GAZP" : Color(red: 18, green: 124, blue: 191),
        "PBF" : .blue
    ]
}

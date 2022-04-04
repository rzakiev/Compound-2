//
//  CompoundGrowthChart.swift
//  Compound 2
//
//  Created by Robert Zakiev on 22.05.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct CompoundGrowthChart: View {
    
    public var chartTitle: String
    
    private let values: [ChartValue]
    private let grossGrowth: Int?
    
    var body: some View {
        Chart(for: .custom(name: chartTitle), grossGrowth: nil, values: values)
    }
    
    init(compounding capital: Double, over numberOfYears: Int, at rate: Double, chartTitle: String) {
        self.values = CompoundGrowthCalculator.compound(capital, over: numberOfYears, at: rate)
        self.chartTitle = chartTitle
        self.grossGrowth = 10 //TODO: Implement this function
    }
}

struct CompoundGrowthChart_Previews: PreviewProvider {
    static var previews: some View {
        CompoundGrowthChart(compounding: 1_000_000, over: 20, at: 20, chartTitle: "")
    }
}

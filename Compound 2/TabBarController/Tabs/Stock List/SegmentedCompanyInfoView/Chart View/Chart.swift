//
//  Chart.swift
//  Compound 2
//
//  Created by Robert Zakiev on 24/08/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

struct Chart: View {
    
    let indicator: Indicator // Financial indicator displayed at the top, like "Revenue" or "Net Profit"
    let grossGrowth: Int? //gross growth of a financial indicator, like "+26%"
    
    var chartValues: [(year: Int, value: Double, growth: Int?)] //the values that populate the chart
//    var chartBars: [ChartBar] //the collection of ChartBar views
    
//    let bounds = Anchor<CGRect>.Source.bounds
    
    var body: some View {
        return VStack(alignment: .center) {
            Text(indicator.rawValue + " (" + (grossGrowth == nil ? "" : String.beautifulGrossGrowthRateString(from: grossGrowth!)) + ")")
            ChartHStack(for: indicator,
                        chartValues: chartValues)
//                .padding(.horizontal, 5.0)
        }
        .frame(height: ChartConstants.maxChartHeight, alignment: .bottomTrailing)
    }
    
    init(for indicator: Indicator, grossGrowth: Int?, values: [(year: Int, value: Double, growth: Int?)]) {
        self.indicator = indicator
        self.grossGrowth = grossGrowth
        
        let numberOfValuesToDrop = ChartConstants.numberOfChartsAllowedOnThisDevice() > values.count ? 0 : values.count - ChartConstants.numberOfChartsAllowedOnThisDevice()
        self.chartValues = Array(values.suffix(from: numberOfValuesToDrop))
    }
}

#if DEBUG
struct ChartPreview: PreviewProvider {
    //MARK: - PreviewProvider
    static var previews: some View {
        Group {
            Chart(for: .interestIncome,
                  grossGrowth: 20,
                  values: [(2014, 10, nil), (2015, 20, 4), (2016, 20, 5), (2017, 30, 5), (2018, 40, 5)])
                .previewLayout(.sizeThatFits)
            
            Chart(for: .revenue,
                  grossGrowth: 22,
                  values: [(2014, 10, nil), (2015, 20, 4), (2016, 20, 5), (2017, 30, 5), (2018, 40, -5)])
                .previewLayout(.sizeThatFits)
//                .background(Color.purple)
            
            Chart(for: .revenue,
              grossGrowth: 20,
              values: [(2014, 10, nil), (2015, 20, 4), (2016, 20, 5), (2017, 30, 5), (2018, 40, -5)])
                .previewLayout(.device)
        }
    }
}
#endif

////MARK: - Initializers
//
//
//
////MARK: - Populating the chart
//extension Chart {
//    func populateCharts(proxy: GeometryProxy) {
//
////        for chartValue in chartValues {
////
////        }
//
//    }
//}

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
    
    var chartValues: [ChartValueWithGrowth] //the values that populate the chart
    
    var body: some View {
        return VStack(alignment: .center) {
            Text(indicator.title + " (" + (grossGrowth == nil ? "" : String.beautifulGrossGrowthRateString(from: grossGrowth!)) + ")")
                .padding(.top, 10)
            
            ChartHStack(for: indicator,
                        chartValues: chartValues)
            Divider()
            
            //                .padding(.horizontal, 5.0)
        }.frame(height: ChartConstants.maxChartHeight, alignment: .bottomTrailing)
        .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
    }
    
    init(for indicator: Indicator, grossGrowth: Int?, values: [ChartValueWithGrowth]) {
        self.indicator = indicator
        self.grossGrowth = grossGrowth
        
        let numberOfValuesToDrop = ChartConstants.numberOfChartsAllowedOnThisDevice() > values.count ? 0 : values.count - ChartConstants.numberOfChartsAllowedOnThisDevice()
        self.chartValues = Array(values.suffix(from: numberOfValuesToDrop))
    }
}

//MARK: - Initializers for production
extension Chart {
    init(produce: Indicator, grossGrowth: Int?, values: [ChartValueWithGrowth]) {
        self.indicator = produce
        self.grossGrowth = grossGrowth
        self.chartValues = values
    }
}

#if DEBUG
struct ChartPreview: PreviewProvider {
    //MARK: - PreviewProvider
    static var previews: some View {
        Group {
            Chart(for: .interestIncome,
                  grossGrowth: 20,
                  values: [.init(year: 2014, value: 10, growth: nil), .init(year: 2015, value: 20, growth: 4), .init(year: 2016, value: 20, growth: 5), .init(year: 2017, value: 30, growth: 5), .init(year: 2018, value: 40, growth: 5)])
                .previewLayout(.sizeThatFits)
            
            Chart(for: .revenue,
                  grossGrowth: 22,
                  values: [.init(year: 2014, value: 10, growth: nil), .init(year: 2015, value: 20, growth: 4), .init(year: 2016, value: 20, growth: 5), .init(year: 2017, value: 30, growth: 5), .init(year: 2018, value: 40, growth: -5)])
                .previewLayout(.sizeThatFits)
                .background(Color.purple)
            
            Chart(for: .revenue,
                  grossGrowth: 20,
                  values: [.init(year: 2014, value: 10, growth: nil), .init(year: 2015, value: 20, growth: 4), .init(year: 2016, value: 20, growth: 5), .init(year: 2017, value: 30, growth: 5), .init(year: 2018, value: 40, growth: -5)])
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

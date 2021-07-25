//
//  ChartHStack.swift
//  Compound 2
//
//  Created by Robert Zakiev on 01/09/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//
//This is an HStack for displaying a collection of ChartBar()

import SwiftUI

struct ChartHStack: View {
    
//    struct ChartValue: Identifiable {
//        let year: Int
//        let value: Double
//        let growth: Int
//        let id = UUID()
//    }

//    fileprivate(set) var chartValues = [ChartValue]()//the values that populate the chart
    
    let chartValues: [ChartValue] //= [(2018, 200, 10), (2019, 250, 25), (2020, 400, 78)]
    let biggestChartValue: ChartValue
    
    let indicator: Indicator
    
    var body: some View {
        GeometryReader { geometry  in
            ScrollView(.horizontal, showsIndicators: false) {
                Spacer()
                HStack(alignment: .bottom) {
                    ForEach(self.chartValues, id: \.year) { chartValue in
                        ChartBar(height: CGFloat(self.chartHeightAndWidth(geometry, chartValue: (chartValue.year, chartValue.value)).height),
                                 width: CGFloat(self.chartHeightAndWidth(geometry, chartValue: (chartValue.year, chartValue.value)).width),
                                 financialIndicator: chartValue.value,
                                 growth: chartValue.growth ?? 0,
                                 year: chartValue.year,
                                 biggerIsBetter: self.indicator == .debtToEBITDA ? false: true )
                    }
                }.padding(.horizontal, 20)
            }
            
//            .background(Color.blue)
//            .padding([.horizontal], 0)
//            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            //.edgesIgnoringSafeArea([.horizontal])
//            .scaledToFit()
//            .background(Color.purple)
        }
    }
    
    func chartHeightAndWidth(_ geometry: GeometryProxy, chartValue: (year: Int, value: Double)) -> (height: CGFloat, width: CGFloat) {
        
        let cellHeight = geometry.size.height
        let cellWidth = geometry.size.width
//        print("Cell width: \(cellWidth)")
//        print("Cell height: \(cellHeight)")
        
        let isBiggestChart = chartValue.year == biggestChartValue.year
//        print("Biggest value: \(biggestChartValue.year), \(biggestChartValue.value)")
        
        let height: CGFloat
        let width: CGFloat
        
        if isBiggestChart {
            height = cellHeight * 0.8 //the biggest chart's height must be 80% of the cell's height
        } else {
            height = cellHeight * 0.8 * CGFloat(chartValue.value) / CGFloat(biggestChartValue.value)
        }
        
        let numberOfChartsToBeDrawn = chartValues.count
        width = cellWidth / CGFloat(numberOfChartsToBeDrawn)
        
        if biggestChartValue.value == 0 { return (0, width) }
        
        if chartValue.value <= 0 { return (0, width) }
        
        if height <= 0 { return (0, width) }
        
        return (height, width)
    }
}

//MARK: - Initializers
extension ChartHStack {
    init(for indicator: Indicator, chartValues: [ChartValue]) {
        self.indicator = indicator
        self.chartValues = chartValues
        
        self.biggestChartValue = chartValues.max(by: <)!
    }
}

//MARK: - SwiftUI Previews
#if DEBUG
struct ChartHStack_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            ChartHStack(for: .revenue,
                        chartValues: [.init(year: 2013, value: 2, growth: 40), .init(year: 2014, value: 5, growth: 30), .init(year: 2016, value: 10, growth: 0), .init(year: 2017, value: 20, growth: 0), .init(year: 2018, value: 30, growth: 90)])
            
                .colorScheme(scheme)
                .previewLayout(.sizeThatFits)
        }
        
//        ChartHStack(chartValues: [(2016, 17.8, 10), (2017, -5, 0), (2018, 39.9, 90)])
    }
}
#endif

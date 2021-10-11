//
//  IdeasUpsideChart.swift
//  Compound 2
//
//  Created by Robert Zakiev on 10.05.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct IdeasUpsideChart: View {
    
    let chartValues: [UpsideChartValue] //= [(2018, 200, 10), (2019, 250, 25), (2020, 400, 78)]
    let biggestChartValue: UpsideChartValue
    
    //MARK: - Initializers
    init(chartValues: [UpsideChartValue]) {
        self.chartValues = chartValues
        self.biggestChartValue = chartValues.max()!
    }
    
    var body: some View {
        GeometryReader { geometry  in
            ScrollView(.horizontal, showsIndicators: false) {
                VStack {
                    chartTitle
                    Spacer()
                    HStack(alignment: .bottom) {
                        ForEach(self.chartValues, id: \.ticker) { chartValue in
                            UpsideChartBar(height: CGFloat(self.chartHeightAndWidth(geometry, chartValue: (chartValue.ticker, Double(chartValue.upside))).height),
                                           width: CGFloat(self.chartHeightAndWidth(geometry, chartValue: (chartValue.ticker, Double(chartValue.upside))).width),
                                           chartValue: chartValue
                            )
                        }
                    }.padding(.horizontal, 20)
                }.frame(maxHeight: 500)
            }
        //            .background(Color.blue)
        //            .padding([.horizontal], 0)
        //            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
        //.edgesIgnoringSafeArea([.horizontal])
        //            .scaledToFit()
        //            .background(Color.purple)
    }
}
    
    var chartTitle: some View {
        
            Text("\(chartValues[0].risk == "high" ? "Высокий" : chartValues[0].risk == "medium" ? "Средний" : chartValues[0].risk == "low" ? "Низкий" : "") риск ")
            .font(.system(size: 40, weight: .bold, design: .rounded))
            .foregroundColor(.black)
            .bold()
            .padding([.top], 20)
        
    }
    
    func chartHeightAndWidth(_ geometry: GeometryProxy, chartValue: (ticker: String, value: Double)) -> (height: CGFloat, width: CGFloat) {
        
        let cellHeight = geometry.size.height
        let cellWidth = geometry.size.width
        
        let isBiggestChart = chartValue.ticker == biggestChartValue.ticker
        
        let height: CGFloat
        let width: CGFloat
        
        if isBiggestChart {
            height = cellHeight * 0.8 //the biggest chart's height must be 80% of the cell's height
        } else {
            height = cellHeight * 0.8 * CGFloat(chartValue.value) / CGFloat(biggestChartValue.upside)
        }
        
        let numberOfChartsToBeDrawn = chartValues.count
        width = cellWidth / CGFloat(numberOfChartsToBeDrawn)
        
        if biggestChartValue.upside == 0 { return (0, width) }
        
        if chartValue.value <= 0 { return (0, width) }
        
        if height <= 80 { return (0, width) } //case where the height of the bar is lower than the texts in the middle (looks bad)
        
        return (height, width)
    }
}

//MARK: - Entities
extension IdeasUpsideChart {
    struct UpsideChartValue: Comparable {
        let ticker: String
        let targetPrice: Double //actual target price in the corresponding currency
        let upside: Double //percentage
        let currency: Currency
        let risk: String
        
        static func < (lhs: IdeasUpsideChart.UpsideChartValue, rhs: IdeasUpsideChart.UpsideChartValue) -> Bool {
            return lhs.upside < rhs.upside
        }
    }
}

struct UpsideChartBar: View {
    
    let height: CGFloat
    let width: CGFloat
    let backgroundColor: Color
    let indicatorAndGrowthText: UpsideChartCenterView
    let currency: Currency
    let ticker: String
    let risk: String
    
    init(height: CGFloat, width: CGFloat, chartValue: IdeasUpsideChart.UpsideChartValue) { //targetPrice: Double, ticker: String, currency: Currency, risk: String
        self.height = height
        self.width = width < C.Chart.maxChartBarWidth ? width : C.Chart.maxChartBarWidth //The width of the chart cannot exceed the maximum allowed chart width
        self.indicatorAndGrowthText = UpsideChartCenterView(upside: chartValue.upside, targetPrice: chartValue.targetPrice, ticker: chartValue.ticker, currency: chartValue.currency)
        self.ticker = chartValue.ticker
        self.backgroundColor = UpsideChartBar.chartBarColor(growth: chartValue.upside, risk: chartValue.risk)
        self.currency = chartValue.currency
        self.risk = chartValue.risk
    }
    
    //Mark: - View Body
    var body: some View {
//        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(backgroundColor)
                    .frame(minWidth: 60, idealWidth: 77, maxWidth: C.Chart.maxChartBarWidth, minHeight: nil, idealHeight: nil, maxHeight: height, alignment: .center)
                indicatorAndGrowthText
            }
//            UpsideChartBarTitle(ticker: ticker)
//        }
    }
    
    static func chartBarColor(growth: Double, risk: String) -> Color {
        if growth >= 0 {
            return risk == "low" ? Color.green : risk == "medium" ? Color.orange : risk == "high" ? Color.red : Color.gray
        } else {
            return Color.gray
        }
    }
}

//the text displayed in the middle of a chart bar containing the financial indicator value and the growth value
struct UpsideChartCenterView: View {
    
    let upside: Double
    let targetPrice: Double
    let ticker: String
    let currency: Currency
    
    var body: some View {
        let indicatorText: String
        indicatorText = currency.sign + targetPrice.beautify()
        
        let growthText = properUpsideText()
        
        return VStack {
            Text(growthText ?? "✅").lineLimit(1)
            Text(indicatorText).lineLimit(2)
            Text(ticker).lineLimit(1)
        }
    }
    
    func properUpsideText() -> String? {
        
        if upside <= 2 {
            return nil
        } else {
            return "\(upside > 0 ? "+" : "")\(Int(upside))%"
        }
    }
}

//the year text displayed underneath the chart bar
struct UpsideChartBarTitle: View {
    let ticker: String
    var body: Text { Text(ticker) }
}

//struct IdeasUpsideChart_Previews: PreviewProvider {
//    static var previews: some View {
//        IdeasUpsideChart(chartValues: [.init(ticker: "PBF", target: 25, upside: T##Int)])
//    }
//}

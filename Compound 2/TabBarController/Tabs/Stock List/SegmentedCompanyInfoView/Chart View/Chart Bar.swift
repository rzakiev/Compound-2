//
//  Chart Bar.swift
//  Compound 2
//
//  Created by Robert Zakiev on 22/08/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

struct ChartBar: View {
    
    let height: CGFloat
    let width: CGFloat
    let backgroundColor: Color
    let indicatorAndGrowthText: ChartBarText
    let year: Int
    
    init(height: CGFloat, width: CGFloat, financialIndicator: Double, growth: Int, year: Int, biggerIsBetter: Bool = true) {
        self.height = height
        self.width = width < C.Chart.maxChartBarWidth ? width : C.Chart.maxChartBarWidth //The width of the chart cannot exceed the maximum allowed chart width
        self.indicatorAndGrowthText = ChartBarText(financialIndicator: financialIndicator, growthIndicator: growth)
        self.year = year
        self.backgroundColor = ChartBar.chartBarColor(growth: growth, biggerIsBetter: biggerIsBetter, year: year )
    }
    
    //Mark: - View Body
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(backgroundColor)
                    .frame(minWidth: 65, idealWidth: 70, maxWidth: C.Chart.maxChartBarWidth, minHeight: nil, idealHeight: nil, maxHeight: height, alignment: .center)
                indicatorAndGrowthText
            }
            YearText(year: year)
        }
    }
    
    static func chartBarColor(growth: Int, biggerIsBetter: Bool, year: Int) -> Color {
        
//        if year > Date.lastYear {
//            return Color.gray //Forecasts should be colored with the gray color
//        }
        
        if biggerIsBetter {
            return growth >= 0 ? Color.green : Color.red
        } else {
            return growth >= 0 ? Color.red : Color.green
        }
    }
    
    
}

//the text displayed in the middle of a chart bar containing the financial indicator value and the growth value
struct ChartBarText: View {
    let financialIndicator: Double
    let growthIndicator: Int
    
    var body: some View {
        let indicatorText: String
        if financialIndicator > 1 { indicatorText = financialIndicator.beautify() }
        else { indicatorText = String(financialIndicator) }
        
        let growthText = properGrowthText()
        
        return VStack {
            Text(indicatorText).lineLimit(1)
            if growthText != nil {
                Text(growthText!).lineLimit(1)
            }
        }
    }
    
    func properGrowthText() -> String? {
        if growthIndicator == 0 {
            return nil
        } else {
            return "\(growthIndicator > 0 ? "+" : "")\(growthIndicator)%"
        }
    }
}

//the year text displayed underneath the chart bar
struct YearText: View {
    let year: Int
    var body: Text {
        Text(String(year))
//        Text(year > Date.lastYear ? String(year) + "П" : String(year))
    }
    
//    func makeProperStringForYearText() -> String {
//        let currentYear = Date()
//    }
}



#if DEBUG
struct ChartBarView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
        ChartBar(height: 200, width: 100, financialIndicator: 100, growth: 34, year: 2014)
            .colorScheme(scheme)
            .previewLayout(.sizeThatFits)
        }
    }
}
#endif

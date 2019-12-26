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
    let yearText: YearText
    
    init(height: CGFloat, width: CGFloat, financialIndicator: Double, growth: Int, year: Int, biggerIsBetter: Bool = true) {
        self.height = height
        self.width = width < ChartConstants.maxChartBarWidth ? width : ChartConstants.maxChartBarWidth //The width of the chart cannot exceed the maximum allowed chart width
        self.indicatorAndGrowthText = ChartBarText(financialIndicator: financialIndicator, growthIndicator: growth)
        self.yearText = YearText(year: year)
        self.backgroundColor = ChartBar.chartBarColor(growth: growth, biggerIsBetter: biggerIsBetter)
    }
    
    //Mark: - View Body
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(backgroundColor)
//                    .frame(width: CGFloat(width), height: CGFloat(height), alignment: .center)
                    .frame(minWidth: nil, idealWidth: width, maxWidth: ChartConstants.maxChartBarWidth, minHeight: nil, idealHeight: nil, maxHeight: height, alignment: .center)
                indicatorAndGrowthText
            }
            yearText
        }
    }
    
    static func chartBarColor(growth: Int, biggerIsBetter: Bool) -> Color {
        if biggerIsBetter {
            return growth >= 0 ? Color.green : Color.red
        } else {
            return growth >= 0 ? Color.red : Color.green
        }
    }
    
    func biggerIsBetter(financialIndicator: Indicator) -> Bool {
        return financialIndicator != .debtToEBITDA //Debt is better when smaller, other indicators are indifferent
    }
}

//the text displayed in the middle of a chart bar containing the financial indicator value and the growth value
struct ChartBarText: View {
    let financialIndicator: Double
    let growthIndicator: Int
    
    var body: some View {
        let indicatorText = String(format:"%.1f", financialIndicator)
        
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
    }
}



#if DEBUG
struct ChartBarView_Previews: PreviewProvider {
    static var previews: some View {
        ChartBar(height: 200, width: 100, financialIndicator: 100, growth: 34, year: 2014)
            .previewLayout(.sizeThatFits)
    }
}
#endif

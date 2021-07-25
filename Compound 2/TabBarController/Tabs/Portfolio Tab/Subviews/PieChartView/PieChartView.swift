//
//  PieChartView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 04.11.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct PieChartView: View {
    
    @State private var portfolio: Portfolio
    
    @State private var selectedSliceIndex: Int? = nil
    
    @State private var sliceIsSelected: Bool = false
    
    let trimRangesForChartSlices: [(from: CGFloat, to: CGFloat)]
    
    var body: some View {
        ZStack {
        ForEach(portfolio.positions.indices) { index in
            Circle()
                .trim(from: trimRangesForChartSlices[index].from, to: trimRangesForChartSlices[index].to)
                .stroke(generateStrokeColor(for: portfolio.positions[index]), lineWidth: 50)
                //                    .scaledToFit()
                .frame(width: 180 + (sliceIsSelected && selectedSliceIndex == index ? 20 : 0),
                       height: 180 + (sliceIsSelected && selectedSliceIndex == index ? 20 : 0)
                )
//                .overlay(Text("\(trimRangesForChartSlices[index].from) to \(trimRangesForChartSlices[index].to)"))
                //                    .scaledToFill()
                .padding(40)
                .onTapGesture { sliceTappedHandler(index) }
        }
            makePieChartCenterView(selectedIndex: selectedSliceIndex)
        }
    }
    
    //MARK: - Initializer
    init(portfolio: Portfolio) {
        _portfolio = State(initialValue: portfolio)
        
        var chartSliceRanges = [(from: CGFloat, to: CGFloat)]()
        for i in 0..<portfolio.positions.count {
            let trimFrom = chartSliceRanges.last?.to ?? 0.0
            let trimTo = trimFrom + CGFloat(portfolio.percentageOfTotalPortfolioForPosition(at: i) ?? 0.1)
            chartSliceRanges.append((trimFrom, trimTo))
        }
        self.trimRangesForChartSlices = chartSliceRanges
        print("RANGES: \(chartSliceRanges)")
    }
}

//MARK: - Labels and Texts
extension PieChartView {
    func makePieChartCenterView(selectedIndex: Int?) -> some View {
        Text(selectedIndex == nil ? "" : portfolio.positions[selectedIndex!].companyName ?? "N/A")
            .lineLimit(1)
    }
}


//MARK: - Drawing the pie chart
extension PieChartView {
    
    private func percentage(for index: Int) -> CGFloat {
        guard let percentage = portfolio.percentageOfTotalPortfolioForPosition(at: index) else {
            Logger.log(error: "No pie chart percentage for \(portfolio.positions[index].ticker)")
            return 10
        }
        return CGFloat(percentage)
    }
    
    private func trimTo(for index: Int) -> CGFloat {
        return CGFloat(index) * 0.1 + 0.2
    }
}


extension PieChartView {
    private func generateStrokeColor(for position: Position) -> Color {
        PieChartColorGenerator.generateColor(forTicker: position.ticker) ?? Color.blue
    }
}

//MARK: - Gestures
extension PieChartView {
    func sliceTappedHandler(_ newIndex: Int) {
        withAnimation {
            if selectedSliceIndex == newIndex { //If tapping on the same pie chart slice
                let _ = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: false) { _ in
                    selectedSliceIndex = nil
                }
                sliceIsSelected.toggle()
            } else { //If tapping on a different pie chart slice
                selectedSliceIndex = newIndex
                sliceIsSelected = true
            }
        }
    }
}


//struct PieChartView_Previews: PreviewProvider {
//    
//    @State var portfolio = Portfolio.makeSamplePortfolio()
//    
//    static var previews: some View {
//        PieChartView(portfolio: $portfolio)
//    }
//}

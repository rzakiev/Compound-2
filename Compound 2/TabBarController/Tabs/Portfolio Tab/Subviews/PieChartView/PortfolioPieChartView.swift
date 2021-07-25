//
//  PortfolioPieChartView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 24.06.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct PortfolioPieChartView: View {
    
    //Use this variable to access the portfolio
    private(set) var portfolio: Portfolio
    
    @State private var selectedSliceIndex: Int? = nil
    @State private var sliceIsSelected: Bool = false
    
    var body: some View {
            ZStack(alignment: .center) {
                PieChartView(portfolio: self.portfolio)
            }
//            .scaledToFit()
            .frame(width: 250, height: 250, alignment: .center)
//            .background(Color.red)
//            Spacer()
        }
//    }
}






struct PortfolioPieChartView_Previews: PreviewProvider {
    
    static var previews: some View {
        PortfolioPieChartView(portfolio: Portfolio(fromLocalStorage: true) ?? Portfolio( positions: []))
    }
}

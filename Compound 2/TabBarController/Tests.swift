//
//  Alerts.swift
//  Compound 2
//
//  Created by Robert Zakiev on 28.11.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI



struct TestsView: View {
    var body: some View {
        VStack {
            CompoundGrowthChart(compounding: 8_000_000, over: 30, at: 10, chartTitle: "10% годовых")
            CompoundGrowthChart(compounding: 8_000_000, over: 30, at: 20, chartTitle: "20% годовых")
            CompoundGrowthChart(compounding: 8_000_000, over: 30, at: 30, chartTitle: "30% годовых")
        }
    }
}

#if DEBUG
struct Alerts_Previews: PreviewProvider {
    static var previews: some View {
        TestsView()
            .previewDevice("iPhone 11")
    }
}
#endif

//
//  Alerts.swift
//  Compound 2
//
//  Created by Robert Zakiev on 28.11.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI
import Combine

struct TestsView: View {
    
//    private(set) var profits = [(company: String, profits: [FinancialFigure])]()
    
    @State var dividends: Dividends = DividendService.fetchDividends(forTicker: "CHMF")!
    
    var body: some View {
        List {
            ForEach(dividends[1].dividends!.indices, id: \.self) { index in
                HStack {
                    Text(self.dividends[1].dividends![index].registryclosedate)
                    Spacer()
                    Text(String(self.dividends[1].dividends![index].value))
                }
            }
        }
        //        Text("Hello")
    }
    
    init() {
//        print(Date.currentDayOfTheWeek)
//        print(Date.todayIsWeekend())
        MoexDataManager.updateAllLocalDataFromMoex()
    }
    
    func receivedQuotes(_ quotes: [Quote]) {
        //        self.dividends = DividendCalculator.dividendsAsPartOfCapitalization(quotes: quotes)
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

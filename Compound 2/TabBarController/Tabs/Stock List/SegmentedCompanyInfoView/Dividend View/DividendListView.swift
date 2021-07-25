//
//  DividendListView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 30.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct DividendListView: View {
    
    let annualDividends: [AnnualDividend]
    
    var body: some View {
        List {
            ForEach(annualDividends.indices, id: \.self) { index in
                HStack {
                    Text(String(self.annualDividends[index].year))
                    Text(String(self.annualDividends[index].totalAnnualPayout))
                }
            }
        }
    }
    
    init(dividends: [DividendElement]) {
        self.annualDividends = MoexDividendService.groupDividendsByYear(dividends)
    }
}



struct AnnualDividend {
    let year: Int
    let payouts: [DividendElement]
    
    var totalAnnualPayout: Double { payouts.map(\.value).reduce(0, +) }
}

struct DividendListView_Previews: PreviewProvider {
    static var previews: some View {
        DividendListView(dividends: MoexDataManager.getDividendDataLocally(forTicker: "AFKS")!.dividends!).colorScheme(.dark)
    }
}



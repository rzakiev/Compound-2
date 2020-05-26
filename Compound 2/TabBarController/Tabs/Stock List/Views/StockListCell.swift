//
//  StockListItem.swift
//  Compound 2
//
//  Created by Robert Zakiev on 25/08/2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

//the view for a stock list item that contains the stock's underlying company's name, and some other information like the revenue growth rate, the dividen yield, etc.
struct StockListCell: View {
    
//    var id = UUID()
    
    let companyName: String
    let cagr: Double?
    
    init(companyName: String, cagr: Double? = nil) {
        self.companyName = companyName
        self.cagr = cagr
    }
    
    var body: some View {
        HStack {
            Text(companyName)
            Spacer()
            if cagr != nil {
                Text("CAGR: " + String(Int(cagr! * 100)) + "%")
            }
        }
    }
}

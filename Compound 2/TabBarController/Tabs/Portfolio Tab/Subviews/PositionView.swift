//
//  PositionView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 14.03.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct PositionView: View {
    
    @State var position: Position
    
    @ObservedObject var quoteService = MoexQuoteService.shared
    
//    var profitOrLoss: Double? { getPositionPL(quote: quoteService.getFullQuote(for: position.companyName)) }
    
    var body: some View {
         
        VStack {
            
            HStack {
                companyName
                Spacer()
                
            }
            
            VStack {
                       ProgressView(value: 0.25)
                       ProgressView(value: 0.75)
            }.progressViewStyle(.automatic)
            
            HStack {
                expectedDividend
                Text(" \(position.averageOpeningPrice)")
                Spacer()
            }
        }.frame(minHeight: 70, alignment: .center)
    }
}

extension PositionView {
    func getPositionPL(quote: SimpleQuote?) -> Double? {
        guard let quote = quote else { return nil }
        return position.profitAsPercentage(quote: quote)
    }
}

//MARK: - SwiftUI Titles
extension PositionView {
    var companyName: some View {
        Text("\(position.companyName ?? "N/A")")
//            .font(.title)
    }
    
//    var currentPL: some View {
//        let unwrappedPL = profitOrLoss ?? -1
//        let formattedPLString = String(format: "%.2f", unwrappedPL)
//        return Text(formattedPLString)
//                .font(.callout)
//    }
    
    var expectedDividend: some View {
        guard let dividends = self.position.expectedDividend else { return Text("NO DIV") }
        return Text("Дивиденды: " + dividends.beautify() + " в год")
    }
}

#if DEBUG
struct PositionView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            PositionView(position: .init(ticker: "SBERP", quantity: 1000, averageOpeningPrice: 216.96, currency: "USD"))
                .previewLayout(.sizeThatFits)
                .colorScheme(scheme)
        }
    }
}
#endif

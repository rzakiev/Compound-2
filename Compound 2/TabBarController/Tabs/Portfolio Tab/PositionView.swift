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
    
    @ObservedObject var quoteService = QuoteService.shared
    
//    var profitOrLoss: Double? { getPositionPL(quote: quoteService.getFullQuote(for: position.companyName)) }
    
    var body: some View {
         
        VStack {
            
            HStack {
                companyName
                Spacer()
                
//                if profitOrLoss != nil { currentPL } //display the current P/L for the position
//                else { withAnimation { ActivitySpinner(color: .orange) } }
            }
            
            Spacer()
            
            HStack {
                expectedDividend
                Text(" \(position.averageOpeningPrice)")
                Spacer()
            }
        }.frame(minHeight: 70, alignment: .center)
    }
}

extension PositionView {
    func getPositionPL(quote: Quote?) -> Double? {
        guard let quote = quote else { return nil }
        return position.profitAsPercentage(quote: quote)
    }
}

//MARK: - SwiftUI Titles
extension PositionView {
    var companyName: some View {
        Text("\(position.companyName)")
            .font(.title)
    }
    
//    var currentPL: some View {
//        let unwrappedPL = profitOrLoss ?? -1
//        let formattedPLString = String(format: "%.2f", unwrappedPL)
//        return Text(formattedPLString)
//                .font(.callout)
//    }
    
    var expectedDividend: some View {
        guard let dividends = self.position.expectedDividend else { return Text("") }
        return Text("Дивиденды: " + String(format: "%.2f", dividends) + " руб. в год")
    }
}

#if DEBUG
struct PositionView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach([ColorScheme.light, .dark], id: \.self) { scheme in
            PositionView(position: .init(companyName: "Сбербанк-п",
                                         lots: [.init(numberOfShares: 1000, openingPrice: 216.96)]))
                .previewLayout(.sizeThatFits)
                .colorScheme(scheme)
        }
    }
}
#endif

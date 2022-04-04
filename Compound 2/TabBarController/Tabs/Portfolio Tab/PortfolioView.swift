//
//  Portfolio.swift
//  Compound 2
//
//  Created by Robert Zakiev on 14.03.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import SwiftUI
import Combine

struct PortfolioView: View {

    @State var displayAddPositionView = false

    @ObservedObject var dataProvider = PortfolioDataProvider()

    var body: some View {

        NavigationView {
            List {
                pieChartView
                positionList
            }.navigationBarTitle("Портфолио", displayMode: .inline)
            .navigationViewStyle(DoubleColumnNavigationViewStyle())
            .navigationBarItems(leading: EditButton(), trailing: addPositionButton)
        }
    }
}

//MARK: - Buttons
extension PortfolioView {
    var addPositionButton: some View {

        Button(action: {
            self.displayAddPositionView = true
        }) {
            Image(systemName: "plus").font(.system(size: 22))
        }
    }
}

//MARK: - Pie Chart View
extension PortfolioView {
    var pieChartView: some View {
        HStack {
            Spacer()
            PortfolioPieChartView(portfolio: dataProvider.portfolio)
            Spacer()
        }
    }
}

//MARK: - Dividends View
extension PortfolioView {

//    var totalDividendFlowView: some View {
//        HStack {
//            Text("Див. Поток: ")
//            Spacer()
//            Text(dataProvider.portfolio.grossDividendFlow.simplify() + "/год")
//        }
//    }

    func dividendListView(position: Position) -> some View {
        if let dividends = MoexDividendService.fetchDividends(forTicker: position.ticker)?[safe: 0]?.dividends {
            return DividendListView(dividends: dividends)
        } else {
            return DividendListView(dividends: [])
        }
    }
}

//MARK: - Populating List with Positions
extension PortfolioView {
    var positionList: some View {
        ForEach(dataProvider.portfolio.positions, id:\.self) { position in
//            NavigationLink(destination: DividendListView(dividends: (MoexDataManager.getDividendDataLocally(forTicker: ConstantTickerSymbols.tickerFor(vtbName: position.companyName) ?? "HELLO")?[safe: 1]?.dividends ?? []))) {
                PositionView(position: position)
//            }
        }//.onDelete { (indexSet) in self.dataProvider.portfolio.removePositions(at: indexSet) }

    }
}

//MARK: - Pop-up Sheets
extension PortfolioView {
//    var addNewPositionView: some View {
//        return AddNewPositionView(displayAddPositionView: self.$displayAddPositionView,
//                                  newPositionAdded: { (company, shareCount, costBasis)   in
//                                    self.dataProvider.portfolio.addNewPosition(companyName: company,
//                                                                               numberOfShares: shareCount,
//                                                                               openingPrice: costBasis)
//                                  })
//    }
}

#if DEBUG
struct Portfolio_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
#endif



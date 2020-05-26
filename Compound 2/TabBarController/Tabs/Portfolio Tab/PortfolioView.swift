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
                HStack {
                    Text("Див. Поток: ")
                    Spacer()
                    Text(String(dataProvider.portfolio.grossDividendFlow))
                }
                ForEach(dataProvider.portfolio.positions) { position in
                    NavigationLink(destination: LotsView(position: position)) {
                        PositionView(position: position)
                    }
                }.onDelete { (indexSet) in self.dataProvider.portfolio.removePositions(at: indexSet) }
                
            }.navigationBarTitle("Портфолио", displayMode: .automatic)
                .navigationBarItems(leading: EditButton(), trailing: addPositionButton)
                .sheet(isPresented: $displayAddPositionView) { self.addNewPositionView }
            
        }//.onDisappear(perform: { self.portfolio.saveToStorage() })
    }
}

//MARK: - Pop-up Sheets
extension PortfolioView {
    var addNewPositionView: some View {
        return AddNewPositionView(displayAddPositionView: self.$displayAddPositionView,
                                  newPositionAdded: { (company, shareCount, costBasis)  in
                                    self.dataProvider.portfolio.addNewPosition(companyName: company,
                                                                  numberOfShares: shareCount,
                                                                  openingPrice: costBasis)
        })
    }
}

//MARK: - Buttons
extension PortfolioView {
    var addPositionButton: some View {
        
        Button(action: {
            self.displayAddPositionView = true
        }) { Image(systemName: "plus").font(.system(size: 22)) }
    }
}

#if DEBUG
struct Portfolio_Previews: PreviewProvider {
    static var previews: some View {
        PortfolioView()
    }
}
#endif

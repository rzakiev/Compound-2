//
//  ProductionChart.swift
//  Compound 2
//
//  Created by Robert Zakiev on 06.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI
//
//struct ProductionChartList: View {
//    
//    let company: String
//    
//    let productionFigures: Production?
//    
//    var body: some View {
//        productionChartList
//    }
//    
//    var productionChartList: some View {
//        ScrollView(.vertical, showsIndicators: false) {
//            ForEach(productionFigures!.produce, id: \.id) { produce in
//                Chart(for: .production(produceName: produce.name, unitOfMeasurement: produce.unitOfMeasurement),
//                      grossGrowth: produce.grossGrowthRate(),
//                      values: produce.growthRateForChart())
//                
//            }//.edgesIgnoringSafeArea([.horizontal])
//            //        .listRowInsets(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
//        }
//    }
//    
//    
//    
//    
//    init(company: String) {
//        self.company = company
//        self.productionFigures = ProductionDataManager.getProductionFigures(for: company)
////        Logger.log(operation: "Initializing the Production Chart List View FOR COMPANY: \(company)")
//    }
//}
//
//
//extension ProductionChartList {
//    
//}
//
//
//
//
//#if DEBUG
//
//struct ProductionChartListPreview: PreviewProvider {
//    static var previews: some View {
//        ProductionChartList(company: "Алроса")
//    }
//}
//
//#endif

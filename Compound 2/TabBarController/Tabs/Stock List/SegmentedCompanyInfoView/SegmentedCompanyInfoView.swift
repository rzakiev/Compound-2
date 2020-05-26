//
//  SegmentedCompanyInfoView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 08.12.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

struct SegmentedCompanyInfoView: View {
    
    let company: String
    
    @State private var selectedSegment = 0
    
    private let segments: [CompanyInfoSegment]
    
    let financialChartsView: FinancialChartList
    
    let ecosystemView: EcosystemMindMapView
    
    let productionChartView: ProductionChartList
    
    init(company: String) {
        self.company = company
        self.segments = Preferences.requiredSegmentsInSegmentedCompanyView(for: company)
        self.financialChartsView = FinancialChartList(company: Company(name: self.company))
        self.ecosystemView = EcosystemMindMapView(company: self.company)
        self.productionChartView = ProductionChartList(company: company)
    }
    
    var body: some View {
        VStack {
            if segments.isEmpty { //do not display the picker view if only financial charts are available
                financialChartsView
            } else {
                Picker(selection: $selectedSegment, label: Text("")) {
                    ForEach(segments.indices, id:\.self) { index in
                        Text( self.segments[index].rawValue).tag(index)
                            .position()
                    }
                }.pickerStyle(SegmentedPickerStyle())
                
                if segments[selectedSegment] == .finances {
                    financialChartsView
                } else if segments[selectedSegment] == .ecosystem {
                    ecosystemView
                } else if segments[selectedSegment] == .production {
                    productionChartView
                }
                else {
                    Text("Still working on it, please wait")
                }
            }
        }
        .navigationBarTitle(Text(company), displayMode: .inline)
    }
    
}

extension SegmentedCompanyInfoView {
    //some cool methods here
}


//MARK: - Previews
#if DEBUG
struct SegmentedCompanyInfoViewPreview: PreviewProvider {
    static var previews: some View {
        Group {
            SegmentedCompanyInfoView(company: "Сбербанк")
                .previewLayout(.sizeThatFits)
            
            
            SegmentedCompanyInfoView(company: "МТС")
                .previewLayout(.device)            
        }
    }
}


#endif

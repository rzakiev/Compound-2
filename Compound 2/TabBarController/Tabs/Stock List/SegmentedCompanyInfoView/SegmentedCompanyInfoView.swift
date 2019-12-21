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
    
    @State var selectedSegment = 0
    
    private let segments: [CompanyInfoSegment]
    
    init(company: String) {
        self.company = company
        self.segments = Preferences.requiredSegmentsInSegmentedCompanyView(for: company)
    }
    
    var body: some View {
        VStack {
            
            Picker(selection: $selectedSegment, label: Text("")) {
                ForEach(segments.indices, id:\.self) { index in
                    Text( self.segments[index].rawValue).tag(index)
                }
            }.pickerStyle(SegmentedPickerStyle())
            
            Divider()
            
            if segments[selectedSegment] == .finances {
                financialChartsView
            } else if segments[selectedSegment] == .ecosystem {
                ecosystemView
            } else {
                Text("Still working on it, please wait")
            }
        }.navigationBarTitle(Text(company), displayMode: .inline)
    }
}

extension SegmentedCompanyInfoView {
    var financialChartsView: some View {
        return ChartList(company: Company(name: self.company))
             
    }
    
    var ecosystemView: some View {
        return EcosystemMindMapView(company: self.company)
    }
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

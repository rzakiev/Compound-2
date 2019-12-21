//
//  MultilpliersView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 11.10.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

struct MultipliersView: View {
    
    let company: Company
    
    var body: some View {
        let availableIndicators = company.availableIndicators()
        
        return List(0..<company.availableIndicators().count) { indicator in
            Text(availableIndicators[indicator].rawValue)
        }
        
        
    }
    
    
}

#if DEBUG
struct MultipliersViewPreview: PreviewProvider {
    static var previews: some View {
        MultipliersView(company: Company(name: "Сбербанк"))
    }
}
#endif

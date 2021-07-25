//
//  Alerts.swift
//  Compound 2
//
//  Created by Robert Zakiev on 28.11.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct TestsView: View {
    
    
    
    
    var body: some View {
       Text("Cool stuff")
    }
    
}

#if DEBUG
struct Alerts_Previews: PreviewProvider {
    static var previews: some View {
        TestsView()
            .previewDevice("iPhone 11")
    }
}
#endif

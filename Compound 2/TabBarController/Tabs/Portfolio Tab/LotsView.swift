//
//  LotsView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 02.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct LotsView: View {
    
    let position: Position
    
    var body: some View {
        List(position.lots) { lot in
            HStack {
                Text(String(lot.openingPrice))
                Spacer()
                Text(String(lot.numberOfShares))
            }
        }
    }
}


#if DEBUG
struct LotsView_Previews: PreviewProvider {
    static var previews: some View {
        LotsView(position: .init(companyName: "МТС", lots: [.init(numberOfShares: 50, openingPrice: 259)]))
    }
}
#endif

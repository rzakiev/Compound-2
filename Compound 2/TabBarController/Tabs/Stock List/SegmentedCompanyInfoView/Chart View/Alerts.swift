//
//  Alerts.swift
//  Compound 2
//
//  Created by Robert Zakiev on 28.11.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI
import CoreGraphics

struct Alerts: View {
    
    @State private var favoriteColor = 0
    
    @State var rectangles: [Int] = [1,2,3]
    
    var body: some View {
        SegmentedCompanyInfoView(company: "Сбербанк")
    }

    var body2: some View {
        VStack {
            HStack {
                ForEach(rectangles, id: \.self) { _ in
                    RoundedRectangle(cornerRadius: CGFloat(integerLiteral: 10), style: .continuous)
                        .frame(width: CGFloat(integerLiteral: 30), height: CGFloat(integerLiteral: 500), alignment: .bottom)
                        .background(Color.green)
                    
                }
            }

            Button(action: {
                self.addNewChart()
            }){ Text("Hit me!") }
        }.navigationBarTitle("Hello")
    }
    
    func addNewChart() {
        rectangles.append(1)
    }
}

#if DEBUG
struct Alerts_Previews: PreviewProvider {
    static var previews: some View {
        Alerts()
    }
}
#endif

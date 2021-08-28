//
//  ActivitySpinner.swift
//  Compound 2
//
//  Created by Robert Zakiev on 21.03.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

struct ActivitySpinner: View {
    
    let color: Color
    let height: CGFloat
    let width: CGFloat
    
    init(color: Color, height: CGFloat = 20, width: CGFloat = 20) {
        self.color = color
        self.height = height
        self.width = width
    }
    
    @State var rotateCircle = false
    
    var body: some View {
        
        return Circle()
            .trim(from: 0, to: 0.8)
            .stroke(color, lineWidth: 4)
            .frame(width: width, height: height)
            .rotationEffect(Angle(degrees: rotateCircle ? 360 : 0))
            .animation(Animation.linear(duration: 1).repeatForever(autoreverses: false), value: 1)
            .onAppear(perform: { startCircleSpin() })
    }
    
    //MARK: - Closures
    func startCircleSpin()  {
        withAnimation { self.rotateCircle = true }
    }
}

#if DEBUG
private struct ActivitySpinnerPreview: PreviewProvider {
    static var previews: some View {
        ActivitySpinner(color: Color.orange)
    }
}
#endif

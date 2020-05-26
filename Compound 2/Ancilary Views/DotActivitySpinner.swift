//
//  SwiftUIView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 06.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct DotActivitySpinner: View {
    
    @ObservedObject var timer = DotActivitySpinner.ActivitySpinnerTimer()
    
    var body: some View {
        Text(timer.text)
    }
}

extension DotActivitySpinner {
    final class ActivitySpinnerTimer: ObservableObject {
        @Published var text: String = "."
        
        init() {
            let _ = Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true, block: { _ in
                if self.text == "....." { self.text = "" }
                self.text += "."
            })
        }
    }
}

#if DEBUG
struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        DotActivitySpinner()
    }
}
#endif

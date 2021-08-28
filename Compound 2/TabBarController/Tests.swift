//
//  Alerts.swift
//  Compound 2
//
//  Created by Robert Zakiev on 28.11.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI

protocol Hello {
    var a: String { get }
}

struct TestsView: View {
    
    struct Yo: Hello {
        let a: String
    }
    
    struct No: Hello {
        let a: String
        func blabla(){}
    }
    
    
    var body: some View {
       Text("Cool stuff")
    }
    
    init() {
        abc(param1: Yo(a: "werwer"))
        abc(param1: No(a: "werwer"))
    }
    
    func abc(param1: Hello) {
        print(param1.a)
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

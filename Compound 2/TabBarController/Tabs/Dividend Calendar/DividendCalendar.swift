//
//  DividendCalendar.swift
//  Compound 2
//
//  Created by Robert Zakiev on 17.11.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct DividendCalendar: View {
    
    @State var payments = DividendCalendarDataProvider()
    
    var body: some View {
        List(payments.dividendPayments) { payment in
            HStack {
                Text((payment.name ?? payment.ticker) + " (" + payment.paymentDate.asString() + ")")
                Spacer()
                Text(String(format: "%0.1f", payment.yield) + "%")
            }
        }
    }
}

struct DividendCalendar_Previews: PreviewProvider {
    static var previews: some View {
        DividendCalendar()
    }
}

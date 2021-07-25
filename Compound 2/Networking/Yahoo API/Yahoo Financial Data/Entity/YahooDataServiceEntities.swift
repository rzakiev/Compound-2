//
//  YahooDataServiceEntities.swift
//  Compound 2
//
//  Created by Robert Zakiev on 07.05.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import Foundation

///Intervals that are passed as query parameters when fetching data from the YahooFinancialDataService
enum YahooFinancialDataInvterval: String {
    case oneMinute = "1m"
    case twoMinutes = "2m"
    case fiveMinutes = "5m"
    case fifteenMinutes = "15m"
    case thirtyMinutes = "30m"
    case sixtyMinutes = "60m"
    case ninetyMinutes = "90m"
    case oneHour = "1h"
    case oneDay = "1d"
    case fiveDays = "5d"
    case oneWeek = "1wk"
    case oneMonth = "1mo"
    case threeMonths = "3mo"
}

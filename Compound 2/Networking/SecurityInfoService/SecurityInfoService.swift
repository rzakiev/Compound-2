//
//  SecurityInfoService.swift
//  Compound 2
//
//  Created by Robert Zakiev on 23.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

final class SecurityServiceInfo: ObservableObject {
    @available(*, unavailable)
    fileprivate init() {  }
}

struct SecurityInfo {
    
}

//MARK: - Static Constants
extension SecurityServiceInfo {
    ///The URL where information about all securities can be retrieved
    private static let securityInfoSourceURL = "https://iss.moex.com/iss/engines/stock/markets/shares/boards/TQBR/securities.json?iss.meta=off&iss.only=securities"
    
    ///Returns information about all securities traded on the moscow exchange, including but not limited to the issue size, name of the company, etc.. Synchronous call.
    static func fetchSecuritiesInfo() -> [SecurityInfo] {
        
        guard let url = URL(string: securityInfoSourceURL) else {
            Logger.log(error: "Unable to create a URL struct using the string: \(securityInfoSourceURL)")
            return []
        }
        
        guard let _ = try? Data(contentsOf: url) else {
            Logger.log(error: "Unable to instantiate an instance of type Data from the URL: \(url)")
            return []
        }
        
        
        
        return []
    }
}


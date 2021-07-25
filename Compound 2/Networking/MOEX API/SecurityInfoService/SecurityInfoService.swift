//
//  SecurityInfoService.swift
//  Compound 2
//
//  Created by Robert Zakiev on 23.05.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct SecurityInfoService {
    @available(*, unavailable)
    fileprivate init() { Logger.log(error: "Initializing an instance of \(Self.self) which is unwarranted") }
}


//MARK: - Static Constants
extension SecurityInfoService {
    ///The URL where information about all securities can be retrieved
    private static let securityInfoSourceURL = "https://iss.moex.com/iss/engines/stock/markets/shares/boards/TQBR/securities.json?iss.meta=off&iss.only=securities"
    
    ///Returns information about all securities traded on the moscow exchange, including but not limited to the issue size, name of the company, etc.. Synchronous call.
    private static func fetchSecuritiesInfo() -> SecuritiesInfo? {
        
        guard let url = URL(string: securityInfoSourceURL) else {
            Logger.log(error: "Unable to create a URL struct using the string: \(securityInfoSourceURL)")
            return nil
        }
        
        guard let jsonData = try? Data(contentsOf: url) else {
            Logger.log(error: "Unable to instantiate an instance of type Data from the URL: \(url)")
            return nil
        }
        
        guard let securities = try? JSONDecoder().decode(Securities.self, from: jsonData) else {
            Logger.log(error: "Unable to decode an instance of struct Securities from JSON")
            return nil
        }
        
//        print(securities.securities.data.map({ $0[$0.count-2] == "D" }))
//        for security in securities.securities.data{
//            let securityType = security[security.count-3]
//            switch securityType {
//            case .string(let type):
//                if type == "D" { print("Type D for \(security[0]); ISIN: \(security[19])") }
//            default:
//                print("Unknown type: \(security[security.count-3])")
//                continue
//            }
//        }
        
        return securities.securities
    }
    
    ///Passes  information about all securities traded on the moscow exchange to the completion handler. Asynchronous call.
    static func fetchSecuritiesInfoAsync(completion: @escaping (SecuritiesInfo?) -> Void, queue: DispatchQueue = .global(qos: .default)) {
        queue.async {
            completion(fetchSecuritiesInfo())
        }
    }
}

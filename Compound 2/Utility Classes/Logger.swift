//
//  Logger.swift
//  Compound 2
//
//  Created by Robert Zakiev on 15.08.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

struct Logger {
    
    static func log(operation: String) {
        print("@LoggerOPERATION: " + operation)
    }
    
    static func log(error: String) {
        print("@LoggerERROR: " + error)
    }
    
    static func log(warning: String) {
        print("@LoggerWARNING: " + warning)
    }
}

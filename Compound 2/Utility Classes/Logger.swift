//
//  Logger.swift
//  Compound 2
//
//  Created by Robert Zakiev on 15.08.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

struct Logger {
    
    private static let logOperations = false
    
    private static let logWarnings = true
    
    private static let logErrors = true
    
    static func log(operation: String) {
        if logOperations { print("@LoggerOPERATION: " + operation) }
    }
    
    static func log(error: String) {
        if logErrors { print("@LoggerERROR: " + error) }
    }
    
    static func log(warning: String) {
        if logWarnings { print("@LoggerWARNING: " + warning) }
    }
}

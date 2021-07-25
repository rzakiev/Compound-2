//
//  System Extensions.swift
//  Compound 2
//
//  Created by Robert Zakiev on 11.12.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

extension UserDefaults {
    
    ///Checks if this is the very first launch of the app
    static func isFirstLaunch() -> Bool {
        
        let alreadyLaunchedBefore = UserDefaults.standard.bool(forKey: "alreadyLaunchedBefore")
        
        if alreadyLaunchedBefore {
            return false //The key is set to true -> therefore it is not first launch
        } else { //The first launch
            UserDefaults.standard.set(true, forKey: "alreadyLaunchedBefore") //setting the key to true during the first launch
            return true
        }
    }
}

extension Array {
    subscript(safe index: Index) -> Element? {
        guard index >= 0 && index < self.count else {
            return nil
        }
        return self[index]
    }
}



extension Dictionary where Value: Equatable {
    func someKey(forValue value: Value) -> Key? { first(where: { $1 == value })?.key }
}

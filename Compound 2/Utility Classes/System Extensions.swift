//
//  System Extensions.swift
//  Compound 2
//
//  Created by Robert Zakiev on 11.12.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation

extension UserDefaults {
    static func isFirstLaunch() -> Bool {
        let alreadyLaunchedBefore = UserDefaults.standard.bool(forKey: "alreadyLaunchedBefore")
        
        if alreadyLaunchedBefore == true {
            return false //The key is set to true -> therefore it is not first launch
        } else { //The first launch
            UserDefaults.standard.set(true, forKey: "alreadyLaunchedBefore") //setting the key to true during the first launch
            return true
        }
    }
}

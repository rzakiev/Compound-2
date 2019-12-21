//
//  ConvenientMethods.swift
//  Compound 2
//
//  Created by Robert Zakiev on 15.08.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

//Just a convenient method for converting garbage like "5221.234234234" into "5.2k"
extension Double {
    func simplify () -> String {
        var simplifiedString: String
        switch self {
        case 1_000..<1_000_000: simplifiedString = "\(String(format: "%.1f",self/1000))K"
        case 1_000_000..<1_000_000_000: simplifiedString = "\(String(format: "%.3f",self/1000000))M"
        case 1_000_000_000..<1_000_000_000_000: simplifiedString = "\(String(format: "%.2f",self/1000000000))B"
        case 1_000_000_000_000...:
            simplifiedString = "\(String(format: "%.3f",self/1000000000000))T"
        default:
            simplifiedString = String(format: "%.1f",self)
        }
        
        if simplifiedString.contains(".0") { simplifiedString.removeSubrange(simplifiedString.range(of: ".0")!) }
        return simplifiedString
    }
}

extension Int {
    func simplify () -> String {
        var simplifiedString: String
        switch self {
        case 1_000..<1_000_000: simplifiedString = "\(String(format: "%.1f",self/1000))K"
        case 1_000_000..<1_000_000_000: simplifiedString = "\(String(format: "%.3f",self/1000000))M"
        case 1_000_000_000..<1_000_000_000_000: simplifiedString = "\(String(format: "%.3f",self/1000000000))T"
        default:
            simplifiedString = String(format: "%.1f",self)
        }
        
        if simplifiedString.contains(".0") { simplifiedString.removeSubrange(simplifiedString.range(of: ".0")!) }
        return simplifiedString
    }
}

//UIColor extension for handling hex codes
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        let int = UInt32()
//        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension Color {
    static var beautifulGreenColor: Color {
        return Color(red: 63, green: 220, blue: 84)
    }
}

//Converts numbers like 25 and -38 into "+25" and "-38"
func numberWithSign (number: Int) -> String {
    if number > 0 {
        return "+" + String(number) + "%"
    } else if number == 0 {
        return ""
    } else { //number <=0
        return "-" + String(number) + "%"
    }
}



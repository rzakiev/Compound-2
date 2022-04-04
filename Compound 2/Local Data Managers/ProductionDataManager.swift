//
//  ProductionDataManager.swift
//  Compound 2
//
//  Created by Robert Zakiev on 04.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

/*struct ProductionDataManager {
    
    public static func listOfAllCompanies() -> [String] {
        var allCompanies = Bundle.main.paths(forResourcesOfType: "plist", inDirectory: productionDataDirectory)
        
        for i in 0..<allCompanies.count {
            allCompanies[i] = String(allCompanies[i].suffix(from: allCompanies[i].range(of: "ProductionFigures/")!.upperBound).dropLast(6)) //dropping '.plist' from the file name
        }
        return allCompanies
    }
    
    public static func getProductionFigures(for company: String) -> Production? {
        guard let plistFilePath = Bundle.main.path(forResource: company,
                                                   ofType: ".plist",
                                                   inDirectory: productionDataDirectory)
            else {
//                Logger.log(warning: "PDM: Unable to fetch the path of the plist file for company \(company)")
                return nil
        }
        
        
        guard let plistData = FileManager.default.contents(atPath: plistFilePath) else {
            Logger.log(error: "PDM: Couldn't load the plist data from path: \(plistFilePath)")
            return nil
        }
        
        return convertPlistDataIntoProductionStruct(plistData, for: company)
    }
}

//Converting the data in the plist files into production figures
extension ProductionDataManager {
    private static func convertPlistDataIntoProductionStruct(_ plistData: Data, for company: String) -> Production? {
        
        guard let plistObject = try? PropertyListSerialization.propertyList(from: plistData, options:PropertyListSerialization.ReadOptions(), format:nil) else {
            Logger.log(error: "PDM: Unable to serialize data from the plist")
            return nil
        }
        
        guard let plistDict = plistObject as? Dictionary<String, AnyObject> else {
            Logger.log(error: "PDM: Unable to cast the object as a dictionary")
            return nil
        }
        
        var produce: [Produce] = []
        for (key, value) in plistDict {
            
            let produceName: String = key
            let unitOfMeasurement: String? = value["unitOfMeasurement"] as? String
            
            guard let produceValues = value["produce"] as? NSMutableArray else { return nil }
            
            let convertedProduceValues = convertIntoSwiftArray(produceValues)
            
            let productionOfOneItem = Produce(name: produceName,
                                              unitOfMeasurement: unitOfMeasurement,
                                              values: convertedProduceValues)
            produce.append(productionOfOneItem)
        }
        
        let totalProdiction = Production(companyName: company, produce: produce)
        
        return totalProdiction
    }
    //Converting the Objective-C array with production figures into a proper Swift array
//    static func convertProductionArrayIntoSwiftArray(production: NSMutableArray) -> [(year: Int, value: Double)] {
//
//    }
}

extension ProductionDataManager {
    //Converting NSMutableArrays into Swift arrays contating tuples with financial indicators value
    private static func convertIntoSwiftArray(_ objectiveCArray: NSMutableArray) -> [(year: Int, value: Double)] {
        var financialIndicatorsArray = [(year: Int, value: Double)]()
        for yearAndValue in objectiveCArray {
            guard let swiftString = yearAndValue as? NSMutableString as String? else { return [] }
            guard let year = Int(swiftString.prefix(4)) else {
                Logger.log(error: "unable to downcast \(swiftString) as a year")
                return []
            } //the first four characters are the year
            guard let value = Double(swiftString.suffix(swiftString.count - 5)) else {
                Logger.log(error: "unable to downcast \(swiftString) as a value")
                return []
            }
            financialIndicatorsArray.append((year, value))
        }
        return financialIndicatorsArray
    }
}

extension ProductionDataManager {
    static func productionFiguresAreAvailable(for company: String) -> Bool {
        guard let _ = Bundle.main.path(forResource: company, ofType: ".plist", inDirectory: productionDataDirectory) else {
            return false
        }
        
        return true
    }
}


extension ProductionDataManager {
    private static let productionDataDirectory = "/ProductionFigures"
}*/

//
//  File System.swift
//  Compound 2
//
//  Created by Robert Zakiev on 08.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation


//MARK: - METHODS FOR THE APPLICATION SUPPORT DIRECTORY
extension FileManager {
    
    ///Saves an instance of Data to the specified subdirectory in the application support directory.
    ///
    ///- Parameter subdirectory: The subdirectory to which the data will be saved
    ///- Parameter name: The name under which the resultant file will be saved
    ///- Parameter extension: The extension under which the file will be saved. The default value is `.json`
    ///- Parameter content: The content that must be saved
    
    static func saveFileToApplicationSupport(in subdirectory: String, name: String, format: String = ".json", content: Data) throws {
        let fileManager = FileManager.default
        if let applicationSupportDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
            let newSubDirectoryPath = applicationSupportDirectory.appendingPathComponent(subdirectory)
            if fileManager.fileExists(atPath: newSubDirectoryPath.path) == false {
                do { try fileManager.createDirectory(atPath: newSubDirectoryPath.path, withIntermediateDirectories: true, attributes: nil) }
                catch { Logger.log(error: "Unable to create a subdirectory \(subdirectory) \(error)") }
            }
        }

        guard let url = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true).appendingPathComponent(subdirectory + "\(name)\(format)")
            else {
                Logger.log(error: "Unable to generate a URL to save a the file named \(name)")
                return
        }
        
        do { try content.write(to: url) }
        catch { Logger.log(error: "Unable to save the data to the specified URL \(url)") }

        
        Logger.log(operation: "Saved a file named \(name) with extension \(format) in directory: applicationSupport/\(subdirectory) ")
    }
    
    ///Returns Data from the specified subdirectory in the application support directory.
    ///
    ///- Parameter subdirectory: The subdirectory where the data is stored
    ///- Parameter name: The name under which the file is stored
    ///- Parameter extension: The extension of the file. The default value is `.json`
    static func getFileFromApplicationSupport(in subdirectory: String, name: String, format: String = ".json") -> Data? {
        guard let url = try? FileManager.default.url(for: .applicationSupportDirectory,
                                                     in: .userDomainMask,
                                                     appropriateFor: nil,
                                                     create: true).appendingPathComponent(subdirectory + name + format ) else { return nil }
        
        guard (try? url.checkResourceIsReachable()) == true else { return nil }
        
        
        guard let data = try? Data(contentsOf: url) else { return nil }
        
        return data
    }
}

extension FileManager {
    ///Returns data stored in the User Resources folder of the main bundle
    static func getFileInUserDirectory(titled title: String, withExtension format: String) -> Data? {

        guard let jsonPath = Bundle.main.path(forResource: title, ofType: format,
                                              inDirectory: C.userDataDirectory)
        else {
            Logger.log(error: "Couldn't load the file titled \(title) with extension \(format) from the user directory")
            return nil
        }

        guard let jsonData = FileManager.default.contents(atPath: jsonPath) else {
            Logger.log(error: "Couldn't load the data from the path: \(jsonPath)")
            return nil
        }

        return jsonData
    }
}



extension FileManager {
    enum DataSavingError: Error {
        case nonExistentPath
        case failedToSaveFile
    }
}



extension FileManager {
    static func getSimulatorFileSystemDirectory() -> String { NSHomeDirectory() }
}

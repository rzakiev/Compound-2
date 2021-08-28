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
    
    static func saveFileToApplicationSupport(in subdirectory: String, name: String, format: String = ".json", content: Data) {
        
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
        
        do {
            try content.write(to: url)
        }
        catch {
            Logger.log(error: "Unable to save the data to the specified URL \(url)")
//            throw DataSavingError.failedToSaveFile
        }
        
        
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
    
    static func getFileURLsInMainBundle(inDirectory directory: String) -> [URL] {
        
        let urlFromPath = URL(fileURLWithPath: Bundle.main.resourcePath! + directory)
        
        guard let fileURLs = try? FileManager.default.contentsOfDirectory(at: urlFromPath, includingPropertiesForKeys: nil, options: [.skipsHiddenFiles]) else {
            Logger.log(error: "Unable to enumerate files in the following directory: \(directory)")
            return []
        }
        
        return fileURLs
    }
    
    static func getFileListInMainBundle(inDirectory directory: String) -> [(name: String, format: String)] {
        
        guard let files = try? FileManager.default.contentsOfDirectory(atPath:  Bundle.main.resourcePath! + directory) else {
            Logger.log(error: "Unable to enumerate files in the following directory: \(directory)")
            return []
        }
        
        var fileNames: [(name: String, format: String)] = []
        for fileName in files {
            let splitName = fileName.split(separator: ".")
            let name = String(splitName[0])
            let format = String(splitName[1])
            fileNames.append((name, format))
        }
        
        return fileNames
    }
    
    static func getFilesInMainBundle(inDirectory directory: String) -> [Data] {
        
        guard let files = try? FileManager.default.contentsOfDirectory(atPath:  Bundle.main.resourcePath! + directory) else {
            Logger.log(error: "Unable to enumerate files in the following directory: \(directory)")
            return []
        }
        
        var fileNames: [(name: String, format: String)] = []
        for fileName in files {
            let splitName = fileName.split(separator: ".")
            let name = String(splitName[0])
            let format = String(splitName[1])
            fileNames.append((name, format))
        }
        
        var filesData = [Data]()
        
        for fileName in fileNames {
            
            guard let jsonPath = Bundle.main.path(forResource: fileName.name, ofType: fileName.format, inDirectory: directory) else {
                Logger.log(error: "No path for \(fileName.name).\(fileName.format) in directory: \(directory)")
                return []
            }
            
            guard let fileData = FileManager.default.contents(atPath: jsonPath) else {
                Logger.log(error: "Unable to get the contents of ")
                return []
            }
            
            filesData.append(fileData)
            
        }
        
        return filesData
    }
}

extension FileManager {
    static var applicationSupportPath: String {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.absoluteString
    }
    
    static var applicationSupportURL: URL? {
        FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
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

//
//  File System.swift
//  Compound 2
//
//  Created by Robert Zakiev on 08.01.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation


extension FileManager {
    
    static func createFile(at directory: String, name: String, withExtension: String, content: Data) throws {
        guard let _ = Bundle.main.path(forResource: name, ofType: withExtension, inDirectory: directory) else {
            throw FileSystemError.failedToCreateFile(named: name, atPath: directory, reason: "The file already exists")
        }
        
    }
    

    static func listAllDividendFiles(inDirectory subpath: String) -> [String] {
        
        let urls = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)
        
        for url in urls {
            print(url)
        }
        return []
    }

}


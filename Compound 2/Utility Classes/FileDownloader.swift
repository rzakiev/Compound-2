//
//  FileDownloader.swift
//  Compound 2
//
//  Created by Robert Zakiev on 16.12.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

///Contains methods for downloading and storing files from the internet
struct FileDownloader {
    
    @available (*, unavailable)
    fileprivate init() { Logger.log(error: "Initializing an instance of \(Self.self) which is unnecessary") }
    
    static func downloadData(at fileURL: String) -> Data? {
        guard let url = URL(string: fileURL) else {
            Logger.log(error: "Unable to instantiate a URL struct from \(fileURL)")
            return nil
        }
        return try? Data(contentsOf: url)
    }
}

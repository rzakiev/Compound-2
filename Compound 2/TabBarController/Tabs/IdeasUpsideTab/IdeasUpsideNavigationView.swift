//
//  IdeasUpsideNavigationView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 02.06.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct IdeasUpsideNavigationView: View {
    
    let fileNames: [(name: String, format: String)]
    
    var body: some View {
        return NavigationView {
            List {
                ForEach(0..<fileNames.count, id: \.self) { i in
                    NavigationLink(destination: IdeasUpsideView(fileName: fileNames[i])) {
                        Text(fileNames[i].name)
                    }
                }
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        }
    }
}

extension IdeasUpsideNavigationView {
    init() {
        guard let files = try? FileManager.default.contentsOfDirectory(atPath:  Bundle.main.resourcePath! + C.UpsidesVariables.upsidesDirectory) else {
            Logger.log(error: "Unable to enumerate files in the following directory: \(C.UpsidesVariables.upsidesDirectory)")
            self.fileNames = []
            return
        }
        
        var names: [(name: String, format: String)] = []
        for fileName in files {
            let splitName = fileName.split(separator: ".")
            let name = String(splitName[0])
            let format = String(splitName[1])
            names.append((name, format))
        }
        
        self.fileNames = names
    }
}

struct IdeasUpsideNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        IdeasUpsideNavigationView()
    }
}

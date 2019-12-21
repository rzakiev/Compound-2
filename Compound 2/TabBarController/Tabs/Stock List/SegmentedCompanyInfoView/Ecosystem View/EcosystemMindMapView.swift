//
//  EcosystemMindMapView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 19.12.2019.
//  Copyright © 2019 Robert Zakiev. All rights reserved.
//

import SwiftUI
import UIKit

struct EcosystemMindMapView: View {
    
    private let companyName: String
    
    private let ecosystemImagePath: String?
    
    var body: some View {
        //
        //        let imageURL = URL(fileURLWithPath: FinancialDataManager.ecosystemImagesSubdirectory).appendingPathComponent(companyName + ".png")
        //        print(imageURL)
        let alternativeImageURL = Bundle.main.url(forResource: companyName, withExtension: ".png", subdirectory: FinancialDataManager.ecosystemImagesSubdirectory)
        //        print(alternativeImageURL ?? "NO URL")
        //        print(alternativeImageURL!.path)
        //        print(FinancialDataManager.resourceIsAvailable(at: alternativeImageURL!.path, named: companyName, ofType: ".png"))
        let image = UIImage(contentsOfFile: alternativeImageURL!.path)
        return
            Group {
            Spacer()
            Image(uiImage: image!)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(Angle(degrees: 90))
                //.scaleEffect(0.8)
        }
    }
    
    init(company: String) {
        self.companyName = company
        
        let ecosystemImagesBundle = Bundle(path: FinancialDataManager.financialDataDirectory + FinancialDataManager.ecosystemImagesSubdirectory)
//
        self.ecosystemImagePath = ecosystemImagesBundle?.path(forResource: companyName, ofType: "png")
    }
}

struct EcosystemMindMapView_Previews: PreviewProvider {
    static var previews: some View {
        EcosystemMindMapView(company: "Сбербанк")
    }
}

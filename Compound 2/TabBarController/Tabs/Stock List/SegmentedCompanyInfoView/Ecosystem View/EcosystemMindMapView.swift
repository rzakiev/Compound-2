////
////  EcosystemMindMapView.swift
////  Compound 2
////
////  Created by Robert Zakiev on 19.12.2019.
////  Copyright © 2019 Robert Zakiev. All rights reserved.
////
//
//import SwiftUI
//import UIKit
//
//struct EcosystemMindMapView: View {
//
//    private let companyName: String
//
//    private let ecosystemImagePath: String?
//
//    var body: some View {
//
//        let ecosystemImageURL = Bundle.main.url(forResource: companyName,
//                                                withExtension: ".png",
//                                                subdirectory: FinancialDataManager.ecosystemImagesSubdirectory)
//        let image = UIImage(contentsOfFile: ecosystemImageURL!.path)
//
//        return VStack {
//            Spacer()
//            Image(uiImage: image!)
//                .resizable()
//                //.rotationEffect(Angle(degrees: 90))
//                .aspectRatio(contentMode: .fit)
//            //.edgesIgnoringSafeArea([.horizontal])
//        }
//
//
//        //return Text("Unable to load the ecosystem image for \(companyName)")
//    }
//
//    init(company: String) {
//        self.companyName = company
//
//        let ecosystemImagesBundle = Bundle(path: FinancialDataManager.corporateDataDirectory + FinancialDataManager.ecosystemImagesSubdirectory)
//        //
//        self.ecosystemImagePath = ecosystemImagesBundle?.path(forResource: companyName, ofType: "png")
////        Logger.log(operation: "Initializing the ecosystem view")
//    }
//}
//
//struct EcosystemMindMapView_Previews: PreviewProvider {
//    static var previews: some View {
//        EcosystemMindMapView(company: "Сбербанк").previewLayout(.device)
//    }
//}

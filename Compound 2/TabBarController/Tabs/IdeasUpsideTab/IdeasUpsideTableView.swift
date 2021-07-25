////
////  IdeasUpsideTableView.swift
////  Compound 2
////
////  Created by Robert Zakiev on 17.04.2021.
////  Copyright © 2021 Robert Zakiev. All rights reserved.
////
//
//import SwiftUI
//
//struct IdeasUpsideTableView: View {
//
//    @ObservedObject var investments = IdeasUpsideDataProvider()
//
//    var body: some View {
//
//
//
//        NavigationView {
//        List {
//            Section(header: Text("США")) {
//                ForEach(investments.ideas.values.filter({ $0.currency != .Rouble }).sorted(by: >), id: \.self) { idea in
//                    HStack {
//                        Text(idea.ticker)
//                        Spacer()
//                        if idea.upside == nil { Text("N/A") }
//                        else { Text("+ \(idea.upside!)%") }
//                    }
//                }
//            }
//            Section(header: Text("РФ")) {
//                ForEach(investments.ideas.values.filter({ $0.currency == .Rouble }).sorted(by: >), id: \.self) { idea in
//                    HStack {
//                        Text(idea.ticker)
//                        Spacer()
//                        if idea.upside == nil { Text("N/A") }
//                        else { Text("+ \(idea.upside!)%") }
//                    }
//                }
//            }
//        }.listStyle(GroupedListStyle())
//        .navigationTitle(Text("Malishok Upsides"))
//        .navigationBarTitleDisplayMode(.inline)
//        }
//    }
//}
//
//struct IdeasUpsideTableView_Previews: PreviewProvider {
//    static var previews: some View {
//        IdeasUpsideTableView()
//    }
//}
//

//
//  TradingView.swift
//  Compound 2
//
//  Created by Robert Zakiev on 21.11.2021.
//  Copyright © 2021 Robert Zakiev. All rights reserved.
//

import SwiftUI
import WebKit

struct TradingViewChart: View {
    
    let ticker: String
    
    private let url: URL
    
    var body: some View {
        WebView(url: url)
    }
    
    init(ticker: String) {
        
        self.ticker = ticker
        
        if let url = URL(string: "https://www.tradingview.com/chart/?symbol=\(ticker)") {
            self.url = url
        } else {
            self.url = URL(string: "https://tradingview.com")!
        }
    }
}


struct TimeOff {
    enum TimeOffType { case partialDay, fullDay }
    enum TimeOffStatus { case submitted, awaitingSupervisorApproval, approved }
    
    let status: TimeOffStatus
    let type: TimeOffType
    
    let startDate: Date
    let endDate: Date
    
    let requestCreationDate: Date
    
}


struct WebView: UIViewRepresentable {
 
    var url: URL
 
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
 
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}

//class WebViewModel: ObservableObject {
//    let webView: WKWebView
//    let url: URL
//
//    init(urlString: String) {
//        webView = WKWebView(frame: .zero)
//        if let initializedURL = URL(string: urlString) {
//            url = initializedURL
//        } else {
//            url = URL(string: "https://tradingview.com")!
//        }
//
//        loadUrl()
//    }
//
//    func loadUrl() {
//        webView.load(URLRequest(url: url))
//    }
//}

//
//  ConversationManager.swift
//  Compound 2
//
//  Created by Robert Zakiev on 06.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation
import SwiftUI

final class ConversationManager: ObservableObject {
    
    @Published var messages: [ConversationMessage] = []
    
    init() {
        initiateConversation()
    }
    
    func initiateConversation() {
        self.messages.append(.init(content: "Чем я могу вам помочь?", isResponse: true))
        let _ = Timer.scheduledTimer(withTimeInterval: 0.7, repeats: false, block: { _ in
            self.messages.append(.init(content: "Хочу", isResponse: false))
            self.messages.append(.init(content: "buySellBlock", isResponse: false))
        })
    }
}

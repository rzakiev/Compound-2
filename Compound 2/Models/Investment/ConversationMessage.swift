//
//  ConversationMessage.swift
//  Compound 2
//
//  Created by Robert Zakiev on 06.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import Foundation

struct ConversationMessage: Identifiable {
    var id = UUID()
    let content: String
    let isResponse: Bool
}

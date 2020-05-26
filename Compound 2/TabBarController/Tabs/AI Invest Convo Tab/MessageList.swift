//
//  MessageList.swift
//  Compound 2
//
//  Created by Robert Zakiev on 06.04.2020.
//  Copyright © 2020 Robert Zakiev. All rights reserved.
//

import SwiftUI

struct MessageList: View {
    
    @ObservedObject var conversationManager = ConversationManager()
    
    var body: some View {
        List {
            ForEach(conversationManager.messages) { message in
                MessageCell(text: message.content, isResponse: message.isResponse)
                    .listRowBackground(Color.black)
            }
        }.listStyle(GroupedListStyle())
        .onAppear() { UITableView.appearance().separatorStyle = .none }
        .onDisappear() { UITableView.appearance().separatorStyle = .singleLine }
    }
}

#if DEBUG
struct MessageList_Previews: PreviewProvider {
    static var previews: some View {
        MessageList()
    }
}
#endif
